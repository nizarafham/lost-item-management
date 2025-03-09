<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Exception\FirebaseException;
use Symfony\Component\HttpKernel\Exception\UnauthorizedHttpException;

class FirebaseTokenMiddleware
{
    public function handle(Request $request, Closure $next)
    {
        $authHeader = $request->header('Authorization');

        if (!$authHeader || !str_starts_with($authHeader, 'Bearer ')) {
            throw new UnauthorizedHttpException('Firebase', 'Invalid Authorization header');
        }

        $idTokenString = substr($authHeader, 7); // Remove "Bearer "

        try {
            $factory = (new Factory())->withServiceAccount(config('filesystems.disks.firebase.credentials'));
            $auth = $factory->createAuth();
            $verifiedIdToken = $auth->verifyIdToken($idTokenString);
            $uid = $verifiedIdToken->claims()->get('sub');

            $request->attributes->add(['firebaseUid' => $uid]); // Simpan UID di request

            return $next($request);

        } catch (FirebaseException $e) {
            throw new UnauthorizedHttpException('Firebase', 'Invalid Firebase token: ' . $e->getMessage());
        }
    }
}
