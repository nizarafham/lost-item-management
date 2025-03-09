<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\ItemController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\LocationController;
use App\Http\Controllers\QrController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware(['firebase.auth'])->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);

    // Items
    Route::post('/lost-items', [ItemController::class, 'createLostItem']);
    Route::get('/lost-items', [ItemController::class, 'getLostItems']);
    Route::post('/found-items', [ItemController::class, 'createFoundItem']);
    Route::get('/found-items', [ItemController::class, 'getFoundItems']);
    Route::get('/found-items/{foundItem}', [ItemController::class, 'getFoundItem']);

    // Categories
    Route::get('/categories', [CategoryController::class, 'getCategories']);
    Route::post('/categories', [CategoryController::class, 'createCategory']);

    // Locations
    Route::get('/locations', [LocationController::class, 'getLocations']);
    Route::post('/locations', [LocationController::class, 'createLocation']);

    // QR Code
    Route::post('/qr-codes/{foundItem}/scan', [QrController::class, 'scanQrCode']);
    Route::get('/qr-codes/{foundItem}', [QrController::class, 'getQrCode']);
});
