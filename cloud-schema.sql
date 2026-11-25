begin;

create table if not exists public.reflection_notebooks (
  owner_id uuid primary key references auth.users (id) on delete cascade,
  content jsonb not null check (jsonb_typeof(content) = 'object'),
  revision integer not null default 1 check (revision > 0)
);
alter table public.reflection_notebooks enable row level security;
revoke all on public.reflection_notebooks from anon, authenticated;
grant select, insert, update on public.reflection_notebooks to authenticated;
drop policy if exists reflection_owner_access on public.reflection_notebooks;
create policy reflection_owner_access on public.reflection_notebooks
  for all to authenticated
  using ((select auth.uid()) = owner_id)
  with check ((select auth.uid()) = owner_id);

commit;
