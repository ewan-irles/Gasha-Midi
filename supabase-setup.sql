-- Tarpin Faim : comptes beta-testeurs, roles et retours
-- A coller UNE FOIS dans Supabase > SQL Editor > New query > Run.

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text,
  role text not null default 'user' check (role in ('user','admin')),
  pseudo text, level int, discovered int, opened int, app_version text,
  created_at timestamptz default now(),
  last_seen timestamptz
);

create table if not exists public.feedback (
  id bigint generated always as identity primary key,
  user_id uuid not null references auth.users(id) on delete cascade default auth.uid(),
  email text,
  rating int check (rating between 1 and 5),
  message text,
  app_version text,
  created_at timestamptz default now()
);

alter table public.profiles enable row level security;
alter table public.feedback enable row level security;

-- Savoir si l'utilisateur connecte est admin (sans boucle de securite)
create or replace function public.is_admin() returns boolean
language sql security definer set search_path = public stable as $$
  select exists (select 1 from public.profiles where id = auth.uid() and role = 'admin')
$$;

-- Profils : chacun voit le sien, l'admin voit tout
drop policy if exists "profiles_select" on public.profiles;
create policy "profiles_select" on public.profiles for select to authenticated
  using (auth.uid() = id or public.is_admin());

-- Chacun peut mettre a jour SON profil, mais jamais son role (colonnes limitees)
drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own" on public.profiles for update to authenticated
  using (auth.uid() = id) with check (auth.uid() = id);
revoke update on public.profiles from anon, authenticated;
grant update (pseudo, level, discovered, opened, app_version, last_seen) on public.profiles to authenticated;

-- Retours : chacun ecrit les siens, l'admin lit tout
drop policy if exists "feedback_insert" on public.feedback;
create policy "feedback_insert" on public.feedback for insert to authenticated
  with check (auth.uid() = user_id);
drop policy if exists "feedback_select" on public.feedback;
create policy "feedback_select" on public.feedback for select to authenticated
  using (auth.uid() = user_id or public.is_admin());

-- Cree automatiquement un profil (role "user") a chaque inscription
create or replace function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, email) values (new.id, new.email)
  on conflict (id) do nothing;
  return new;
end $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
  for each row execute function public.handle_new_user();

-- Si tu t'es DEJA inscrit avant d'avoir lance ce script, cree ton profil :
insert into public.profiles (id, email)
  select id, email from auth.users on conflict (id) do nothing;

-- TON COMPTE ADMIN : remplace l'email puis lance cette ligne APRES t'etre inscrit dans l'app.
-- update public.profiles set role = 'admin' where email = 'ton-email@exemple.com';

-- Suppression de compte par l'utilisateur lui-meme (bouton Reglages > Supprimer mon compte)
create or replace function public.delete_my_account() returns void
language plpgsql security definer set search_path = public, auth as $$
begin
  delete from auth.users where id = auth.uid();
end $$;
revoke all on function public.delete_my_account() from public, anon;
grant execute on function public.delete_my_account() to authenticated;

-- Durcissement : ces fonctions ne doivent pas etre appelables par n'importe qui depuis internet.
-- Le trigger d'inscription n'a besoin d'aucun droit d'appel public : il tourne tout seul.
revoke execute on function public.handle_new_user() from public, anon, authenticated;

-- is_admin() est utilisee par les regles de securite : seuls les connectes en ont besoin.
revoke execute on function public.is_admin() from public, anon;
grant execute on function public.is_admin() to authenticated;

-- Suppression de compte : reservee aux connectes (jamais aux anonymes).
revoke execute on function public.delete_my_account() from public, anon;
grant execute on function public.delete_my_account() to authenticated;
