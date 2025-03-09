<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class LostItemsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $locations = ['Semua', 'Griya Legita', 'GOR', 'Selasar', 'Kantin', 'Parkiran'];
        $categories = ['Semua', 'Kunci', 'KTM', 'Dompet', 'Lainnya'];

        // Contoh data (Anda bisa menambahkan lebih banyak data sesuai kebutuhan)
        $lostItems = [
            [
                'user_id' => 1, 
                'category_id' => 2, // Ganti dengan category_id yang valid
                'description' => 'Kunci Motor Hilang',
                'location' => $locations[1], // Griya Legita
                'date_lost' => Carbon::now()->subDays(2),
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'user_id' => 2, // Ganti dengan user_id yang valid
                'category_id' => 3, // Ganti dengan category_id yang valid
                'description' => 'KTM Hilang',
                'location' => $locations[3], // Selasar
                'date_lost' => Carbon::now()->subHours(12),
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'user_id' => 1, // Ganti dengan user_id yang valid
                'category_id' => 4, // Ganti dengan category_id yang valid
                'description' => 'Dompet Coklat Hilang',
                'location' => $locations[4], // Kantin
                'date_lost' => Carbon::now()->subMinutes(30),
                'created_at' => now(),
                'updated_at' => now(),
            ],
            // Tambahkan data lainnya di sini
        ];

        DB::table('lost_items')->insert($lostItems);
    }
}
