package com.app.breadman.retrofit;


import com.app.breadman.util.Constant;

import retrofit2.converter.gson.GsonConverterFactory;
import retrofit2.converter.jackson.JacksonConverterFactory;
import retrofit2.converter.scalars.ScalarsConverterFactory;

public class ApiClient {

    private static retrofit2.Retrofit retrofit = null;

    public static ApiInterface getClient() {

        if (retrofit == null) {

            retrofit = new retrofit2.Retrofit.Builder()
                    .baseUrl(Constant.BASE_URL)
                    .addConverterFactory(ScalarsConverterFactory.create())
                    .addConverterFactory(GsonConverterFactory.create())
//                    .addConverterFactory(JacksonConverterFactory.create())
                    .build();

        }
        return retrofit.create(ApiInterface.class);
    }


}