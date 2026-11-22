# Activer les comptes beta-testeurs (une seule fois)

Le code est deja dans l'app, il est « endormi » tant qu'on ne lui donne pas l'adresse de ta base Supabase.

1. Cree un compte gratuit sur https://supabase.com, puis **New project** (nom : tarpin-faim, region : Europe). Garde le mot de passe de la base quelque part.
2. **SQL Editor > New query** : colle tout le contenu de `supabase-setup.sql` et clique **Run**.
3. **Authentication > Providers > Email** : pour une beta simple, desactive **Confirm email** (sinon chaque testeur doit cliquer un lien dans un mail avant de se connecter).
4. **Authentication > URL Configuration** : mets le **Site URL** sur l'adresse de ton app GitHub Pages (https://ewan-irles.github.io/Gasha-Midi/ par exemple) et ajoute la meme adresse dans **Redirect URLs**.
5. **Project Settings > API** : copie la **Project URL** et la cle **anon public** (elle est faite pour etre publique, ce n'est pas un secret). Ne copie JAMAIS la cle `service_role`.
6. Donne ces deux valeurs a Claude : il les branche dans l'app et publie.
7. Inscris-toi toi-meme dans l'app, puis dans Supabase (SQL Editor) lance :
   `update public.profiles set role = 'admin' where email = 'ton-email@exemple.com';`
   Au prochain lancement, tu vois le bouton Admin dans ton profil.

## Google (optionnel, plus tard)
Authentication > Providers > Google : Supabase affiche un lien de redirection a copier dans un projet Google Cloud (console.cloud.google.com > APIs & Services > Credentials > OAuth client ID, type Web). Tu recopies ensuite le Client ID et le Client Secret dans Supabase, puis tu dis a Claude d'activer le bouton Google.
