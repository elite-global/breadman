package com.app.breadman.util;

import android.app.Activity;
import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.support.v4.app.FragmentActivity;
import android.view.View;
import android.view.inputmethod.InputMethodManager;


public class Constant {

    //////////// constent data

    public static String signup_as ;


    ////////////

    private Context context;
    /*
      * ALL URLS
       */

    // base url
    public static final String BASE_URL = "http://foodservices.co.in/foodservices/api/";

    public static String URL_LOGIN = BASE_URL + "login";

    public static String URL_REGISTER = BASE_URL + "register";

    public static String URL_VERIFY_OTP = BASE_URL + "otpVerification";

    public static String URL_SEND_OTP = BASE_URL + "forgetpassword";

    public static String URL_RESET_PASSWORD = BASE_URL + "resetpassword";

    public static String URL_CHANGE_PASSWORD = BASE_URL + "changePassword";

    public static String URL_CONNECT_SUPPLIER = BASE_URL + "connectsupplier";

    public static String URL_GET_USER_NOTIFICATION = BASE_URL + "getUserNotifications";




    Constant(Context context) {
        this.context = context;
    }

    /*
    *  END ALL URLS
     */

    /*
     * ALL KEYS
     *
     */


    // login

    public static final String KEY_PASSWORD = "password";
    public static final String KEY_EMAIL = "email";
    public static final String KEY_USER_TYPE = "user_type";
    public static final String KEY_DEVICE_ID = "device_id";
    public static final String KEY_DEVICE_TYPE = "device_type";
    public static final String KEY_VENDER_ID = "vender_id";
    public static final String KEY_ID = "id";
    public static final String KEY_USER_ID = "user_id";
    public static final String KEY_IS_ACTIVE = "is_active";
    public static final String KEY_OTP = "otp";
    public static final String KEY_NEW_PASSWORD = "new_password";
    public static final String KEY_OLD_PASSWORD = "old_password";
    public static final String KEY_SUPPLIER_ID = "supplier_id";


    public static final String KEY_FNAME = "first_name";
    public static final String KEY_LNAME = "last_name";
    public static final String KEY_PHONE = "phone";
    public static final String KEY_ADDRESS = "address";
    public static final String KEY_PINCODE = "pincode";
    public static final String KEY_PROFILE = "profile";
    public static final String KEY_RATE_PER_KG = "rate_per_kg";
    public static final String KEY_DAILY_AVG_QUANTITY = "daily_avg_quantity";
    public static final String KEY_IS_DELETED = "is_deleted";



    public static void hideKeyboard(Context ctx) {
        InputMethodManager inputManager = (InputMethodManager) ctx
                .getSystemService(Context.INPUT_METHOD_SERVICE);

        // check if no view has focus:
        View v = ((Activity) ctx).getCurrentFocus();
        if (v == null)
            return;

        inputManager.hideSoftInputFromWindow(v.getWindowToken(), 0);
    }

    public static boolean isConnected(FragmentActivity context) {

        boolean connected = false;
        ConnectivityManager connectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        //we are connected to a network
        connected = connectivityManager.getNetworkInfo(ConnectivityManager.TYPE_MOBILE).getState() == NetworkInfo.State.CONNECTED ||
                connectivityManager.getNetworkInfo(ConnectivityManager.TYPE_WIFI).getState() == NetworkInfo.State.CONNECTED;

        return connected;
    }

}
