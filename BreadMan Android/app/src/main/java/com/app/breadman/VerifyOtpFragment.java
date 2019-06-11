package com.app.breadman;


import android.app.ProgressDialog;
import android.content.Intent;
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

public class VerifyOtpFragment extends Fragment implements View.OnClickListener {

    private View v;
    private SessionManagement session;
    private HashMap<String, String> user;

    private Button btn_verify;
    private EditText et_otp;
    private TextView tv_signin, tv_resend;

    private ProgressDialog pd;
    private String strOtp;
    private String device_id;

    private String str_userid;
    private String str_email;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_verify_otp, container, false);

        return v;
    }

    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        this.v = view;

        session = new SessionManagement(getActivity());
        user = session.getUserDetails();

        str_userid = user.get(SessionManagement.KEY_USER_ID);
        str_email = user.get(SessionManagement.KEY_EMAIL);

        init();
        listeners();

    }

    private void init() {

        et_otp = v.findViewById(R.id.et_otp);

        device_id = Settings.Secure.getString(getActivity().getContentResolver(), Settings.Secure.ANDROID_ID);

        btn_verify = v.findViewById(R.id.btn_verify);
        tv_signin = v.findViewById(R.id.tv_signin);
        tv_resend = v.findViewById(R.id.tv_resend);

    }

    private void listeners() {

        btn_verify.setOnClickListener(this);
        tv_signin.setOnClickListener(this);
        tv_resend.setOnClickListener(this);

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

        if (view == tv_resend) {

            ReSendOtp();

        }

        if (view == btn_verify) {

            if (et_otp.getText().toString().trim().length() == 0) {

                Snackbar snackbar = Snackbar
                        .make(btn_verify, "Enter otp", Snackbar.LENGTH_LONG)
                        .setAction("OTP", new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {

                            }
                        });

                snackbar.show();
            } else {

                if (et_otp.getText().toString().trim().length() == 4) {

                    if (Constant.isConnected(getActivity()) == false) {
                        Snackbar snackbar1 = Snackbar
                                .make(btn_verify, "No Internet Connection Found", Snackbar.LENGTH_LONG)
                                .setAction("", new View.OnClickListener() {
                                    @Override
                                    public void onClick(View view) {
                                    }
                                });

                        snackbar1.show();

                    } else {

                        Verify();

                    }

                } else {
                    Snackbar snackbar = Snackbar
                            .make(btn_verify, "Enter Valid Otp", Snackbar.LENGTH_LONG)
                            .setAction("OTP", new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                }
                            });

                    snackbar.show();

                }

            }


        }

    }


    private void Verify() {

        pd = new ProgressDialog(getActivity());
        pd.setMessage("loading...");
        pd.setCancelable(false);
        pd.show();

        strOtp = et_otp.getText().toString().trim();


        StringRequest stringRequest = new StringRequest(Request.Method.POST, Constant.URL_VERIFY_OTP,
                new Response.Listener<String>() {

                    @Override
                    public void onResponse(String response) {
                        Log.e("res>", response);

                        pd.dismiss();

                        try {

                            JSONObject jsonObject = new JSONObject(response);

                            if (jsonObject.getBoolean("status") == true) {

                                Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_SHORT).show();

                                session.OtpUpdate("1");

                                Intent i = new Intent(getActivity(), MainActivity.class);
                                startActivity(i);


                            } else {

                                Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_SHORT).show();

                            }

                        } catch (JSONException e) {
                            Log.e("EXCEPTION", String.valueOf(e));
                            Snackbar.make(btn_verify, e.toString(), Snackbar.LENGTH_LONG).show();
                        }

                    }

                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {

                        pd.dismiss();

                        Snackbar.make(btn_verify, error.toString(), Snackbar.LENGTH_LONG).show();
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

                map1.put(Constant.KEY_USER_ID, str_userid);
                map1.put(Constant.KEY_OTP, strOtp);


                Log.e("TOKEN", String.valueOf(map1));

                return map1;

            }
        };


        RequestQueue requestQueue = Volley.newRequestQueue(getActivity());
        requestQueue.add(stringRequest);

    }

    private void ReSendOtp() {

        pd = new ProgressDialog(getActivity());
        pd.setMessage("loading...");
        pd.setCancelable(false);
        pd.show();


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

                            } else {

                                Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_SHORT).show();

                            }

                        } catch (JSONException e) {
                            Log.e("EXCEPTION", String.valueOf(e));
                            Snackbar.make(btn_verify, e.toString(), Snackbar.LENGTH_LONG).show();
                        }

                    }

                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {

                        pd.dismiss();

                        Snackbar.make(btn_verify, error.toString(), Snackbar.LENGTH_LONG).show();
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

                map1.put(Constant.KEY_EMAIL, str_email);

                Log.e("TOKEN", String.valueOf(map1));

                return map1;

            }
        };


        RequestQueue requestQueue = Volley.newRequestQueue(getActivity());
        requestQueue.add(stringRequest);

    }



}


