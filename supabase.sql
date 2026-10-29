-- 三语词卡：在 Supabase 后台 SQL Editor 里粘贴全部内容，点 Run 运行一次即可

-- 每个用户一行，保存学习进度、设置和当日新词数
create table if not exists public.progress (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  cards      jsonb not null default '{}'::jsonb,
  settings   jsonb,
  daily      jsonb,
  reset_at   timestamptz,
  updated_at timestamptz not null default now()
);

-- 开启行级权限：每个人只能读写自己的那一行
alter table public.progress enable row level security;

drop policy if exists "read own progress"   on public.progress;
drop policy if exists "insert own progress" on public.progress;
drop policy if exists "update own progress" on public.progress;

create policy "read own progress" on public.progress
  for select to authenticated using ((select auth.uid()) = user_id);

create policy "insert own progress" on public.progress
  for insert to authenticated with check ((select auth.uid()) = user_id);

create policy "update own progress" on public.progress
  for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
