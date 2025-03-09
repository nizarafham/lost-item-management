<?php

namespace App\Http\Controllers;

use App\Models\LostItem;
use App\Models\FoundItem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ItemController extends Controller
{
    public function createLostItem(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'category_id' => 'required|exists:categories,id',
            'description' => 'required|string',
            'location' => 'required|string',
            'date_lost' => 'required|date',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }

        $firebaseUid = $request->attributes->get('firebaseUid');

        $lostItem = LostItem::create([
            'user_id' => $firebaseUid, // Simpan Firebase UID
            'category_id' => $request->category_id,
            'description' => $request->description,
            'location' => $request->location,
            'date_lost' => $request->date_lost,
        ]);

        return response()->json($lostItem, 201);
    }

    public function createFoundItem(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'category_id' => 'required|exists:categories,id',
            'description' => 'required|string',
            'location' => 'required|string',
            'date_found' => 'required|date',
            'image_url' => 'nullable|string', // Tambahkan validasi untuk image_url
            'qr_code' => 'nullable|string', // Tambahkan validasi untuk qr_code
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }

        $firebaseUid = $request->attributes->get('firebaseUid');

        $foundItem = FoundItem::create([
            'user_id' => $firebaseUid, // Simpan Firebase UID
            'category_id' => $request->category_id,
            'description' => $request->description,
            'location' => $request->location,
            'date_found' => $request->date_found,
            'image_url' => $request->image_url,
            'qr_code' => $request->qr_code,
        ]);

        return response()->json($foundItem, 201);
    }
}
