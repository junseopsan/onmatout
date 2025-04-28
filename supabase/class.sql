-- 수업 테이블
CREATE TABLE public.classes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    teacher_id UUID REFERENCES auth.users(id) NOT NULL,
    start_time TIMESTAMP WITH TIME ZONE NOT NULL,
    end_time TIMESTAMP WITH TIME ZONE NOT NULL,
    max_participants INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 수업 예약 테이블
CREATE TABLE public.class_reservations (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    class_id UUID REFERENCES public.classes(id) ON DELETE CASCADE NOT NULL,
    user_id UUID REFERENCES auth.users(id) NOT NULL,
    reserved_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    attended BOOLEAN DEFAULT false NOT NULL,
    attended_at TIMESTAMP WITH TIME ZONE,
    UNIQUE(class_id, user_id)
);

-- 출석 테이블
CREATE TABLE public.class_attendance (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    class_id UUID REFERENCES public.classes(id) ON DELETE CASCADE NOT NULL,
    user_id UUID REFERENCES auth.users(id) NOT NULL,
    attended_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    note TEXT
);

-- 회원권 테이블
CREATE TABLE public.memberships (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) NOT NULL,
    remaining_sessions INTEGER DEFAULT 0 NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 수업 메모 테이블
CREATE TABLE public.class_notes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    class_id UUID REFERENCES public.classes(id) ON DELETE CASCADE NOT NULL,
    author_id UUID REFERENCES auth.users(id) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- RLS 활성화
ALTER TABLE public.classes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.class_reservations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.class_attendance ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.memberships ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.class_notes ENABLE ROW LEVEL SECURITY;

-- RLS 정책
-- classes
CREATE POLICY "Allow select for authenticated users" ON public.classes
  FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Allow modify for teacher" ON public.classes
  FOR ALL USING (auth.uid() = teacher_id);

-- class_reservations
CREATE POLICY "Allow reservation for self" ON public.class_reservations
  FOR ALL USING (auth.uid() = user_id);

-- class_attendance
CREATE POLICY "Allow select for self or teacher" ON public.class_attendance
  FOR SELECT USING (
    auth.uid() = user_id OR
    auth.uid() = (SELECT teacher_id FROM public.classes WHERE id = class_id)
  );
CREATE POLICY "Allow modify for teacher" ON public.class_attendance
  FOR ALL USING (
    auth.uid() = (SELECT teacher_id FROM public.classes WHERE id = class_id)
  );

-- memberships
CREATE POLICY "Allow access for self" ON public.memberships
  FOR ALL USING (auth.uid() = user_id);

-- class_notes
CREATE POLICY "Allow select for teacher or author" ON public.class_notes
  FOR SELECT USING (
    auth.uid() = author_id OR
    auth.uid() = (SELECT teacher_id FROM public.classes WHERE id = class_id)
  );
CREATE POLICY "Allow modify for author" ON public.class_notes
  FOR ALL USING (auth.uid() = author_id); 

