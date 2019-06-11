package com.app.breadman;


import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.provider.MediaStore;
import android.provider.Settings;
import android.support.design.widget.Snackbar;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.app.breadman.util.Constant;
import com.app.breadman.util.SessionManagement;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.TimeZone;

public class LoginFragment extends Fragment implements View.OnClickListener {

    private View v;
    private Button btnlogin;
    private EditText etlogin_email, etlogin_password;
    private TextView tvSignup, tvForgotpassword;
    private String emailPattern;
    private String email_verified;
    private SessionManagement session;

    private ProgressDialog pd;
    private String strLoginEmail, strLoginPassword, strDeviceToken;
    private String device_id;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_login, container, false);

        return v;
    }

    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        this.v = view;

        init();
        listeners();

    }

    private void init() {

        etlogin_email = v.findViewById(R.id.etlogin_email);
        etlogin_password = v.findViewById(R.id.etlogin_password);
        etlogin_email.setText("");
        etlogin_password.setText("");

        emailPattern = "[a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]+";

        session = new SessionManagement(getActivity());

        device_id = Settings.Secure.getString(getActivity().getContentResolver(), Settings.Secure.ANDROID_ID);

        btnlogin = v.findViewById(R.id.btnlogin);
        tvSignup = v.findViewById(R.id.tvSignup);
        tvForgotpassword = v.findViewById(R.id.tvForgotpassword);

    }

    private void listeners() {

        btnlogin.setOnClickListener(this);
        tvSignup.setOnClickListener(this);
        tvForgotpassword.setOnClickListener(this);

    }

    private static boolean isValidPhoneNumber(String mobile) {
        String regEx = "^[0-9]{10,12}$";
        return mobile.matches(regEx);
    }

    @Override
    public void onClick(View view) {

        Constant.hideKeyboard(getActivity());

        if (view == tvForgotpassword) {

            Fragment fragment = new ForgotPasswordFragment();
            FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
            ft.replace(R.id.container, fragment);
            ft.addToBackStack(null);
            ft.commit();

        }

        if (view == tvSignup) {

            chooseDialog();
        }

        if (view == btnlogin) {

            if (etlogin_email.getText().toString().trim().length() == 0) {

                Snackbar snackbar = Snackbar
                        .make(btnlogin, "Enter Email", Snackbar.LENGTH_LONG)
                        .setAction("Email", new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {

                            }
                        });

                snackbar.show();
            } else {

                if (etlogin_email.getText().toString().trim().matches(emailPattern)) {

                    if (etlogin_password.getText().toString().trim().length() == 0) {
                        Snackbar snackbar = Snackbar
                                .make(btnlogin, "Enter Password", Snackbar.LENGTH_LONG)
                                .setAction("Password", new View.OnClickListener() {
                                    @Override
                                    public void onClick(View view) {
                                    }
                                });

                        snackbar.show();
//                    } else if (etlogin_password.getText().toString().trim().length() < 6) {
//                        Snackbar snackbar = Snackbar
//                                .make(btnlogin, "Password length should be 6", Snackbar.LENGTH_LONG)
//                                .setAction("Password", new View.OnClickListener() {
//                                    @Override
//                                    public void onClick(View view) {
//                                    }
//                                });
//
//                        snackbar.show();
                    } else {

                        if (Constant.isConnected(getActivity()) == false) {
                            Snackbar snackbar1 = Snackbar
                                    .make(btnlogin, "No Internet Connection Found", Snackbar.LENGTH_LONG)
                                    .setAction("", new View.OnClickListener() {
                                        @Override
                                        public void onClick(View view) {
                                        }
                                    });

                            snackbar1.show();

                        } else {

                            login();

                        }

                    }

                } else {
                    Snackbar snackbar = Snackbar
                            .make(btnlogin, "Enter Valid Email", Snackbar.LENGTH_LONG)
                            .setAction("Email", new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                }
                            });

                    snackbar.show();

                }

            }

        }

    }

    private void chooseDialog() {

        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        builder.setCancelable(true);
        LayoutInflater dialog_inflater = (getActivity()).getLayoutInflater();
        View dialog_view = dialog_inflater.inflate(R.layout.dialog_choose_signup, null);
        Button btn_customer = (Button) dialog_view.findViewById(R.id.btn_customer);
        Button btn_supplier = (Button) dialog_view.findViewById(R.id.btn_supplier);
        builder.setView(dialog_view);
        final Dialog choosedialog = builder.create();
        choosedialog.show();

        btn_customer.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                choosedialog.dismiss();

                Constant.signup_as = "customer";

                Fragment fragment = new SignUpFragment();
                FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
                ft.replace(R.id.container, fragment);
                ft.addToBackStack(null);
                ft.commit();

            }
        });

        btn_supplier.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                choosedialog.dismiss();

                Constant.signup_as = "supplier";

                Fragment fragment = new SignUpFragment();
                FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
                ft.replace(R.id.container, fragment);
                ft.addToBackStack(null);
                ft.commit();

            }
        });

    }

    private void login() {

        pd = new ProgressDialog(getActivity());
        pd.setMessage("loading...");
        pd.setCancelable(false);
        pd.show();

        strLoginEmail = etlogin_email.getText().toString().trim();
        strLoginPassword = etlogin_password.getText().toString().trim();


        StringRequest stringRequest = new StringRequest(Request.Method.POST, Constant.URL_LOGIN,
                new Response.Listener<String>() {

                    @Override
                    public void onResponse(String response) {
                        Log.e("res>", response);

                        pd.dismiss();

                        try {

                            JSONObject jsonObject = new JSONObject(response);


                            if (jsonObject.getBoolean("status") == true) {

                                String user_id, supplier_id, user_type, email, is_active, first_name, last_name, phone, address,
                                        pincode, profile, rate_per_kg, daily_avg_quantity, is_deleted;

                                JSONObject jsonObject1 = jsonObject.getJSONObject("data");

                                user_id = jsonObject1.getString(Constant.KEY_ID);
                                supplier_id = jsonObject1.getString(Constant.KEY_VENDER_ID);
                                user_type = jsonObject1.getString(Constant.KEY_USER_TYPE);
                                email = jsonObject1.getString(Constant.KEY_EMAIL);
                                is_active = jsonObject1.getString(Constant.KEY_IS_ACTIVE);
                                first_name = jsonObject1.getString(Constant.KEY_FNAME);
                                last_name = jsonObject1.getString(Constant.KEY_LNAME);
                                phone = jsonObject1.getString(Constant.KEY_PHONE);
                                address = jsonObject1.getString(Constant.KEY_ADDRESS);
                                pincode = jsonObject1.getString(Constant.KEY_PINCODE);
                                profile = jsonObject1.getString(Constant.KEY_PROFILE);
                                rate_per_kg = jsonObject1.getString(Constant.KEY_RATE_PER_KG);
                                daily_avg_quantity = jsonObject1.getString(Constant.KEY_DAILY_AVG_QUANTITY);
                                is_deleted = jsonObject1.getString(Constant.KEY_IS_DELETED);

                                etlogin_email.setText("");
                                etlogin_password.setText("");

                                Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_SHORT).show();

                                if("0".equalsIgnoreCase(is_active)) {

                                    session.LoginOtp(user_id, supplier_id, user_type, email, is_active, first_name, last_name, phone, address,
                                            pincode, profile, rate_per_kg, daily_avg_quantity, is_deleted);

                                    Fragment fragment = new VerifyOtpFragment();
                                    FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
                                    ft.replace(R.id.container, fragment);
                                    ft.addToBackStack(null);
                                    ft.commit();

                                }else if("1".equalsIgnoreCase(is_active)){

                                    session.Login(user_id, supplier_id, user_type, email, is_active, first_name, last_name, phone, address,
                                            pincode, profile, rate_per_kg, daily_avg_quantity, is_deleted);

                                    Intent i = new Intent(getActivity(), MainActivity.class);
                                    startActivity(i);

                                }

                            } else {

                                Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_SHORT).show();

                            }

                        } catch (JSONException e) {
                            Log.e("EXCEPTION", String.valueOf(e));
                            Snackbar.make(btnlogin, e.toString(), Snackbar.LENGTH_LONG).show();
                        }

                    }

                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {

                        pd.dismiss();

                        Snackbar.make(btnlogin, error.toString(), Snackbar.LENGTH_LONG).show();
                    }
                }) {

            @Override
            public Map<String, String> getHeaders() {
                Map<String, String> map = new HashMap<String, String>();

//                map.put(Constant.KEY_ACCEPT, "application/json");
//                map.put(Constant.KEY_CONTENT_TYPE, "application/x-www-form-urlencoded");

                map.put("token", "");
                map.put("Content-Type", "application/x-www-form-urlencoded");

                return map;

            }

            @Override
            public Map<String, String> getParams() {
                Map<String, String> map1 = new HashMap<String, String>();

                map1.put(Constant.KEY_EMAIL, strLoginEmail);
                map1.put(Constant.KEY_PASSWORD, strLoginPassword);
                map1.put(Constant.KEY_DEVICE_ID, device_id);

                Log.e("TOKEN", String.valueOf(map1));

                return map1;

            }
        };


        RequestQueue requestQueue = Volley.newRequestQueue(getActivity());
        requestQueue.add(stringRequest);

    }


}


