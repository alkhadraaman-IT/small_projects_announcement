<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    //
 public function store()
    {
        return $this->belongsTo(Store::class); // منتج يتبع لمحل واحد
    }

public function type()
    {
        return $this->belongsTo(Type::class); // منتج يتبع نوع واحد
    }
    
public function favorites()
    {
return $this->hasMany(Favorite::class); // ✅
    }
}
