-- Enable Row Level Security
ALTER TABLE public.asanas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.journals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.routines ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.journal_asanas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.routine_steps ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Create asanas table
CREATE TABLE public.asanas (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    sanskrit_name_kr TEXT NOT NULL,
    sanskrit_name_en TEXT NOT NULL,
    asana_type TEXT NOT NULL,
    level INTEGER NOT NULL,
    effect_point TEXT NOT NULL,
    effect TEXT NOT NULL,
    story TEXT NOT NULL,
    story_point TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create journals table
CREATE TABLE public.journals (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) NOT NULL,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create routines table
CREATE TABLE public.routines (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    is_default BOOLEAN DEFAULT false NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create user_favorites table
CREATE TABLE public.user_favorites (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) NOT NULL,
    asana_id UUID REFERENCES public.asanas(id) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(user_id, asana_id)
);

-- Create journal_asanas table
CREATE TABLE public.journal_asanas (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    journal_id UUID REFERENCES public.journals(id) ON DELETE CASCADE NOT NULL,
    asana_id UUID REFERENCES public.asanas(id) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create routine_steps table
CREATE TABLE public.routine_steps (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    routine_id UUID REFERENCES public.routines(id) ON DELETE CASCADE NOT NULL,
    asana_id UUID REFERENCES public.asanas(id) NOT NULL,
    asana_name TEXT NOT NULL,
    asana_image_url TEXT,
    duration INTEGER NOT NULL,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create profiles table
CREATE TABLE public.profiles (
    id UUID REFERENCES auth.users(id) PRIMARY KEY,
    phone TEXT UNIQUE NOT NULL,
    nickname TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

create table asanaCategory (
  id uuid primary key default uuid_generate_v4(),
  number integer unique not null,
  posture_type_en text not null,
  posture_type_ko text not null,
  movement_type_en text not null,
  movement_type_ko text not null,
  category_name_en text not null,
  category_name_ko text not null,
  created_at timestamp with time zone default timezone('utc', now())
);


-- Create RLS policies
CREATE POLICY "Enable read access for all users" ON public.asanas
    FOR SELECT USING (true);

CREATE POLICY "Enable insert for authenticated users only" ON public.journals
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Enable read access for authenticated users" ON public.journals
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Enable update for authenticated users" ON public.journals
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Enable delete for authenticated users" ON public.journals
    FOR DELETE USING (auth.uid() = user_id);

CREATE POLICY "Enable insert for authenticated users only" ON public.routines
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Enable read access for authenticated users" ON public.routines
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Enable update for authenticated users" ON public.routines
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Enable delete for authenticated users" ON public.routines
    FOR DELETE USING (auth.uid() = user_id);

CREATE POLICY "Enable insert for authenticated users only" ON public.user_favorites
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Enable read access for authenticated users" ON public.user_favorites
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Enable delete for authenticated users" ON public.user_favorites
    FOR DELETE USING (auth.uid() = user_id);

-- Create RLS policies for profiles
CREATE POLICY "Enable read access for authenticated users" ON public.profiles
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Enable insert for authenticated users only" ON public.profiles
    FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Enable update for authenticated users" ON public.profiles
    FOR UPDATE USING (auth.uid() = id);

-- Create indexes
CREATE INDEX idx_journals_user_id ON public.journals(user_id);
CREATE INDEX idx_routines_user_id ON public.routines(user_id);
CREATE INDEX idx_user_favorites_user_id ON public.user_favorites(user_id);
CREATE INDEX idx_journal_asanas_journal_id ON public.journal_asanas(journal_id);
CREATE INDEX idx_routine_steps_routine_id ON public.routine_steps(routine_id);

-- Create trigger to handle profile creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, phone)
    VALUES (new.id, new.phone);
    RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user(); 