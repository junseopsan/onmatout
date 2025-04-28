-- 1. users 테이블 생성
CREATE TABLE public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  display_name TEXT,
  bio TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  last_login_at TIMESTAMP WITH TIME ZONE,
  streak_count INT DEFAULT 0,  -- 연속 수련 일수
  total_practice_days INT DEFAULT 0  -- 총 수련 일수
);

-- 2. 새로운 asanas 테이블 생성
CREATE TABLE public.asanas (
    id SERIAL PRIMARY KEY,
    sanskrit_name_kr VARCHAR(100) NOT NULL,
    sanskrit_name_en VARCHAR(100) NOT NULL,
    asana_type VARCHAR(50) NOT NULL,
    level INTEGER NOT NULL,
    effect_point TEXT NOT NULL,
    effect TEXT NOT NULL,
    story TEXT NOT NULL,
    story_point TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. user_asana_favorites 테이블 생성
CREATE TABLE public.user_asana_favorites (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  asana_id INTEGER NOT NULL REFERENCES public.asanas(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, asana_id)
);

-- 4. user_asana_progress 테이블 생성
CREATE TABLE public.user_asana_progress (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  asana_id INTEGER NOT NULL REFERENCES public.asanas(id) ON DELETE CASCADE,
  practice_count INT DEFAULT 0,  -- 수련 횟수
  last_practiced_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, asana_id)
);

-- 5. daily_routines 테이블 생성
CREATE TABLE public.daily_routines (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  title TEXT NOT NULL,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, date)
);

-- 6. daily_routine_asanas 테이블 생성
CREATE TABLE public.daily_routine_asanas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  routine_id UUID NOT NULL REFERENCES public.daily_routines(id) ON DELETE CASCADE,
  asana_id INTEGER NOT NULL REFERENCES public.asanas(id) ON DELETE CASCADE,
  "order" INT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(routine_id, "order")
);

-- 7. practice_journals 테이블 생성
CREATE TABLE public.practice_journals (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  duration_minutes INT NOT NULL,
  routine_id UUID REFERENCES public.daily_routines(id) ON DELETE SET NULL,
  notes TEXT,
  mood TEXT NOT NULL,  -- 감정 상태 이모지
  energy_level INT DEFAULT 3 CHECK (energy_level BETWEEN 1 AND 5),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 8. practice_achievements 테이블 생성
CREATE TABLE public.practice_achievements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  achievement_type TEXT NOT NULL,  -- 'streak', 'practice_days', 'asana_count' 등
  value INT NOT NULL,
  achieved_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, achievement_type)
);

-- 9. practice_stamps 테이블 생성
CREATE TABLE public.practice_stamps (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  stamp_type TEXT NOT NULL,  -- 도장 종류
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, date)
);

-- 인덱스 생성
CREATE INDEX idx_user_asana_progress_user_id ON public.user_asana_progress(user_id);
CREATE INDEX idx_daily_routines_user_date ON public.daily_routines(user_id, date);
CREATE INDEX idx_practice_journals_user_date ON public.practice_journals(user_id, date);
CREATE INDEX idx_practice_achievements_user_id ON public.practice_achievements(user_id);
CREATE INDEX idx_practice_stamps_user_date ON public.practice_stamps(user_id, date);