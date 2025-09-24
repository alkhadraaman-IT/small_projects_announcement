<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Announcement extends Model
{
    //
    public function store()
    {
        return $this->belongsTo(Store::class); // ← هون كانت الغلطة: كنت رابطها بـ User بدل Store
    }
}
