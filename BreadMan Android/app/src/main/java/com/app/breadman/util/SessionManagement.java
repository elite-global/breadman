package com.app.breadman.util;


import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.util.Log;

import com.app.breadman.LoginActivity;
import java.util.HashMap;

public class SessionManagement {

    // Shared Preferences
    SharedPreferences pref;

    // Editor for Shared preferences
    SharedPreferences.Editor editor;

    // Context
    Context _context;

    // Shared pref mode
    int PRIVATE_MODE = 0;

    // Sharedpref file name
    private static final String PREF_NAME = "breadman";

    // All Shared Preferences Keys
    private static final String IS_LOGIN = "IsLoggedIn";


    public static final String KEY_PASSWORD = "password";
    public static final String KEY_EMAIL = "email";
    public static final String KEY_USER_TYPE = "user_type";
    public static final String KEY_DEVICE_ID = "device_id";
    public static final String KEY_USER_ID = "user_id";
    public static final String KEY_VENDER_ID = "vender_id";
    public static final String KEY_IS_ACTIVE = "is_active";

    public static final String KEY_FNAME = "first_name";
    public static final String KEY_LNAME = "last_name";
    public static final String KEY_PHONE = "phone";
    public static final String KEY_ADDRESS = "address";
    public static final String KEY_PINCODE = "pincode";
    public static final String KEY_PROFILE = "profile";
    public static final String KEY_RATE_PER_KG = "rate_per_kg";
    public static final String KEY_DAILY_AVG_QUANTITY = "daily_avg_quantity";
    public static final String KEY_IS_DELETED = "is_deleted";




    // Constructor
    public SessionManagement(Context context) {
        this._context = context;
        pref = _context.getSharedPreferences(PREF_NAME, PRIVATE_MODE);
        editor = pref.edit();
    }

    public void Login(String user_id, String supplier_id, String user_type, String email, String is_active, String first_name, String last_name, String phone, String address,
                      String pincode, String profile, String rate_per_kg, String daily_avg_quantity, String is_deleted){

        // Storing login value as TRUE
        editor.putBoolean(IS_LOGIN, true);

        editor.putString(KEY_USER_ID, user_id);
        editor.putString(KEY_VENDER_ID, supplier_id);
        editor.putString(KEY_USER_TYPE, user_type);
        editor.putString(KEY_EMAIL, email);
        editor.putString(KEY_IS_ACTIVE, is_active);
        editor.putString(KEY_FNAME, first_name);
        editor.putString(KEY_LNAME, last_name);
        editor.putString(KEY_PHONE, phone);
        editor.putString(KEY_ADDRESS, address);
        editor.putString(KEY_PINCODE, pincode);
        editor.putString(KEY_PROFILE, profile);
        editor.putString(KEY_RATE_PER_KG, rate_per_kg);
        editor.putString(KEY_DAILY_AVG_QUANTITY, daily_avg_quantity);
        editor.putString(KEY_IS_DELETED, is_deleted);


        // commit changes
        editor.commit();
    }

    public void LoginOtp(String user_id, String supplier_id, String user_type, String email, String is_active, String first_name, String last_name, String phone, String address,
                      String pincode, String profile, String rate_per_kg, String daily_avg_quantity, String is_deleted){

        // Storing login value as TRUE
        editor.putBoolean(IS_LOGIN, false);

        editor.putString(KEY_USER_ID, user_id);
        editor.putString(KEY_VENDER_ID, supplier_id);
        editor.putString(KEY_USER_TYPE, user_type);
        editor.putString(KEY_EMAIL, email);
        editor.putString(KEY_IS_ACTIVE, is_active);
        editor.putString(KEY_FNAME, first_name);
        editor.putString(KEY_LNAME, last_name);
        editor.putString(KEY_PHONE, phone);
        editor.putString(KEY_ADDRESS, address);
        editor.putString(KEY_PINCODE, pincode);
        editor.putString(KEY_PROFILE, profile);
        editor.putString(KEY_RATE_PER_KG, rate_per_kg);
        editor.putString(KEY_DAILY_AVG_QUANTITY, daily_avg_quantity);
        editor.putString(KEY_IS_DELETED, is_deleted);


        // commit changes
        editor.commit();
    }

    public void Signup(String user_id, String supplier_id, String user_type, String email, String is_active){


        // Storing login value as TRUE
        editor.putBoolean(IS_LOGIN, false);

        editor.putString(KEY_USER_ID, user_id);
        editor.putString(KEY_VENDER_ID, supplier_id);
        editor.putString(KEY_USER_TYPE, user_type);
        editor.putString(KEY_EMAIL, email);
        editor.putString(KEY_IS_ACTIVE, is_active);


        // commit changes
        editor.commit();
    }

    public void OtpUpdate(String is_active){


        // Storing login value as TRUE
        editor.putBoolean(IS_LOGIN, true);

        editor.putString(KEY_IS_ACTIVE, is_active);


        // commit changes
        editor.commit();
    }



    public HashMap<String, String> getUserDetails() {
        HashMap<String, String> user = new HashMap<String, String>();

        user.put(KEY_USER_ID, pref.getString(KEY_USER_ID, null));
        user.put(KEY_VENDER_ID, pref.getString(KEY_VENDER_ID, null));
        user.put(KEY_USER_TYPE, pref.getString(KEY_USER_TYPE, null));
        user.put(KEY_EMAIL, pref.getString(KEY_EMAIL, null));
        user.put(KEY_IS_ACTIVE, pref.getString(KEY_IS_ACTIVE, null));
        user.put(KEY_FNAME, pref.getString(KEY_FNAME, null));
        user.put(KEY_LNAME, pref.getString(KEY_LNAME, null));
        user.put(KEY_PHONE, pref.getString(KEY_PHONE, null));
        user.put(KEY_ADDRESS, pref.getString(KEY_ADDRESS, null));
        user.put(KEY_PINCODE, pref.getString(KEY_PINCODE, null));
        user.put(KEY_PROFILE, pref.getString(KEY_PROFILE, null));
        user.put(KEY_RATE_PER_KG, pref.getString(KEY_RATE_PER_KG, null));
        user.put(KEY_DAILY_AVG_QUANTITY, pref.getString(KEY_DAILY_AVG_QUANTITY, null));
        user.put(KEY_IS_DELETED, pref.getString(KEY_IS_DELETED, null));


        // return user
        return user;
    }

    /**
     * Clear session details
          */
    public void logoutUser() {
        // Clearing all data from Shared Preferences
        editor.clear();
        editor.commit();

        // After logout redirect user to Login Activity
        Intent i = new Intent(_context, LoginActivity.class);
        // Closing all the Activities
        i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);

        // Add new Flag to start new Activity
        i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

        // Staring Login Activity
        _context.startActivity(i);

    }


    /**
     * Quick check for login
     **/
    // Get Login State
    public boolean isLoggedIn() {
        return pref.getBoolean(IS_LOGIN, false);
    }

////    public void checkLogin(){
////        // Check login status
////        if(!this.isLoggedIn()){
////            // user is not logged in redirect him to Login Activity
////            Intent i = new Intent(_context, LoginActivity.class);
////            // Closing all the Activities
////            i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
////
////            // Add new Flag to start new Activity
////            i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
////
////            // Staring Login Activity
////            _context.startActivity(i);
////        }
////
////    }
//
//}


}
