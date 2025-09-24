<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class StoreClassController extends Controller
{
    //
    public function index() {
    // عرض قائمة
    $classes = StoreClass::all();
    return response()->json($classes);
}

public function create() {
    // عرض نموذج إنشاء
}

public function store(Request $request) {
    // تخزين بيانات جديدة
}

public function show($id) {
    // عرض بيانات محددة
}

public function edit($id) {
    // عرض نموذج تعديل
}

public function update(Request $request, $id) {
    // تحديث بيانات
}

public function destroy($id) {
    // حذف بيانات
}

}
