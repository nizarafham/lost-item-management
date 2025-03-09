<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class QrCode extends Model
{
    use HasFactory;
    protected $fillable = ['user_id', 'found_item_id', 'scan_date'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function foundItem()
    {
        return $this->belongsTo(FoundItem::class);
    }
}
