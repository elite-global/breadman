package com.app.breadman;


import android.app.ProgressDialog;
import android.os.Bundle;
import android.provider.Settings;
import android.support.design.widget.Snackbar;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
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

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class ForgotPasswordFragment extends Fragment implements View.OnClickListener {

    private View v;
    private Button btn_otp;
    private EditText et_email;
    private TextView tv_signin;
    private String emailPattern;
    private String email_verified;
    private SessionManagement session;

    private ProgressDialog pd;
    public static String strEmail;
    private String strDeviceToken;
    private String device_id;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_forgot_password, container, false);

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

        et_email = v.findViewById(R.id.et_email);

        emailPattern = "[a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]+";

        session = new SessionManagement(getActivity());

        device_id = Settings.Secure.getString(getActivity().getContentResolver(), Settings.Secure.ANDROID_ID);

        btn_otp = v.findViewById(R.id.btn_otp);
        tv_signin = v.findViewById(R.id.tv_signin);

    }

    private void listeners() {

        btn_otp.setOnClickListener(this);
        tv_signin.setOnClickListener(this);

    }

    private static boolean isValidPhoneNumber(String mobile) {
        String regEx = "^[0-9]{10,12}$";
        return mobile.matches(regEx);
    }

    @Override
    public void onClick(View view) {

        Constant.hideKeyboard(getActivity());

        if (view == tv_signin) {

            Fragment fragment = new LoginFragment();
            FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
            ft.replace(R.id.container, fragment);
            ft.addToBackStack(null);
            ft.commit();

        }

        if (view == btn_otp) {

            if (et_email.getText().toString().trim().length() == 0) {

                Snackbar snackbar = Snackbar
                        .make(btn_otp, "Enter Email", Snackbar.LENGTH_LONG)
                        .setAction("Email", new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {

                            }
                        });

                snackbar.show();
            } else {

                if (et_email.getText().toString().trim().matches(emailPattern)) {

                    if (Constant.isConnected(getActivity()) == false) {
                        Snackbar snackbar1 = Snackbar
                                .make(btn_otp, "No Internet Connection Found", Snackbar.LENGTH_LONG)
                                .setAction("", new View.OnClickListener() {
                                    @Override
                                    public void onClick(View view) {
                                    }
                                });

                        snackbar1.show();

                    } else {

                        SendOtp();

                    }

                } else {
                    Snackbar snackbar = Snackbar
                            .make(btn_otp, "Enter Valid Email", Snackbar.LENGTH_LONG)
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


    private void SendOtp() {

        pd = new ProgressDialog(getActivity());
        pd.setMessage("loading...");
        pd.setCancelable(false);
        pd.show();

        strEmail = et_email.getText().toString().trim();


        StringRequest stringRequest = new StringRequest(Request.Method.POST, Constant.URL_SEND_OTP,
                new Response.Listener<String>() {

                    @Override
                    public void onResponse(String response) {
                        Log.e("res>", response);

                        pd.dismiss();

                        try {

                            JSONObject jsonObject = new JSONObject(response);

                            if (jsonObject.getBoolean("status") == true) {

                                Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_SHORT).show();

                                Fragment fragment = new ResetPasswordFragment();
                                FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
                                ft.replace(R.id.container, fragment);
                                ft.addToBackStack(null);
                                ft.commit();

                            } else {

                                Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_SHORT).show();

                            }

                        } catch (JSONException e) {
                            Log.e("EXCEPTION", String.valueOf(e));
                            Snackbar.make(btn_otp, e.toString(), Snackbar.LENGTH_LONG).show();
                        }

                    }

                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {

                        pd.dismiss();

                        Snackbar.make(btn_otp, error.toString(), Snackbar.LENGTH_LONG).show();
                    }
                }) {

            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
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

                map1.put(Constant.KEY_EMAIL, strEmail);

                Log.e("TOKEN", String.valueOf(map1));

                return map1;

            }
        };


        RequestQueue requestQueue = Volley.newRequestQueue(getActivity());
        requestQueue.add(stringRequest);


    }


}


