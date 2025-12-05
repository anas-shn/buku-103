-- Create buku table
CREATE TABLE IF NOT EXISTS public.buku (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    judul TEXT NOT NULL,
    harga INTEGER NOT NULL DEFAULT 0,
    jumlah INTEGER NOT NULL DEFAULT 0,
    tanggal_masuk TEXT NOT NULL,
    volume INTEGER NOT NULL DEFAULT 1,
    penulis TEXT NOT NULL,
    penerbit TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_buku_judul ON public.buku(judul);
CREATE INDEX IF NOT EXISTS idx_buku_penulis ON public.buku(penulis);
CREATE INDEX IF NOT EXISTS idx_buku_penerbit ON public.buku(penerbit);

-- Enable Row Level Security (RLS)
ALTER TABLE public.buku ENABLE ROW LEVEL SECURITY;

-- Create policies for RLS
-- Policy: Allow public read access
CREATE POLICY "Allow public read access" ON public.buku
    FOR SELECT
    USING (true);

-- Policy: Allow authenticated users to insert
CREATE POLICY "Allow authenticated insert" ON public.buku
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

-- Policy: Allow authenticated users to update
CREATE POLICY "Allow authenticated update" ON public.buku
    FOR UPDATE
    USING (auth.role() = 'authenticated')
    WITH CHECK (auth.role() = 'authenticated');

-- Policy: Allow authenticated users to delete
CREATE POLICY "Allow authenticated delete" ON public.buku
    FOR DELETE
    USING (auth.role() = 'authenticated');

-- Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = TIMEZONE('utc'::text, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to call the function
CREATE TRIGGER set_updated_at
    BEFORE UPDATE ON public.buku
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

-- Insert sample data (optional, you can remove this if not needed)
INSERT INTO public.buku (judul, harga, jumlah, tanggal_masuk, volume, penulis, penerbit) VALUES
    ('Laskar Pelangi', 85000, 10, '2024-01-15', 1, 'Andrea Hirata', 'Bentang Pustaka'),
    ('Bumi Manusia', 95000, 15, '2024-01-20', 1, 'Pramoedya Ananta Toer', 'Lentera Dipantara'),
    ('Perahu Kertas', 75000, 8, '2024-02-01', 1, 'Dee Lestari', 'Bentang Pustaka');
