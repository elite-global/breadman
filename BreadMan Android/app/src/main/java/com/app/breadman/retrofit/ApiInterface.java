package com.app.breadman.retrofit;


import com.android.volley.Response;
import com.google.gson.JsonObject;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.List;

import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.Header;
import retrofit2.http.Headers;
import retrofit2.http.Multipart;
import retrofit2.http.POST;
import retrofit2.http.Part;


public interface ApiInterface {


    @Multipart
    @POST("updateProfileCustomer")
    Call<String> UpdateProfileCustomer(
            @Part("user_id") RequestBody userid,
            @Part("first_name") RequestBody fname,
            @Part("last_name") RequestBody lname,
            @Part("phone") RequestBody phone,
            @Part("email") RequestBody email,
            @Part("address") RequestBody address,
            @Part MultipartBody.Part imageFile);


    @Multipart
    @POST("updateProfileSupplier")
    Call<String> UpdateProfileSupplier(@Part("user_id") RequestBody userid,
                                       @Part("first_name") RequestBody fname,
                                       @Part("last_name") RequestBody lname,
                                       @Part("email") RequestBody email,
                                       @Part("phone") RequestBody phone,
                                       @Part("address") RequestBody address,
                                       @Part("pincode") RequestBody pincode,
                                       @Part("rate_per_kg") RequestBody rate,
                                       @Part("daily_avg_quantity") RequestBody avg,
                                       @Part MultipartBody.Part imageFile);


}

