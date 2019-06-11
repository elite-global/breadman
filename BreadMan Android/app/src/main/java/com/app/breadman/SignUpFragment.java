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

public class SignUpFragment extends Fragment implements View.OnClickListener {

    private View v;
    private Button btn_signup;
    private EditText et_email, et_password;
    private TextView tv_signin, tv_signupType;
    private String emailPattern;
    private String email_verified;
    private SessionManagement session;

    private ProgressDialog pd;
    private String strEmail, strPassword, strDeviceToken;
    private String device_id;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_signup, container, false);

        return v;
    }

    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        this.v = view;

        session = new SessionManagement(getActivity());


        init();
        listeners();

    }

    private void init() {

        et_email = v.findViewById(R.id.et_email);
        et_password = v.findViewById(R.id.et_password);
        tv_signupType = v.findViewById(R.id.tv_signupType);

        if("customer".equalsIgnoreCase(Constant.signup_as)){

            tv_signupType.setText("C U S T O M E R");

        }else {

            tv_signupType.setText("S U P P L I E R / V E N D O R");
        }

        emailPattern = "[a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]+";

        device_id = Settings.Secure.getString(getActivity().getContentResolver(), Settings.Secure.ANDROID_ID);

        btn_signup = v.findViewById(R.id.btn_signup);
        tv_signin = v.findViewById(R.id.tv_signin);

    }

    private void listeners() {

        btn_signup.setOnClickListener(this);
        tv_signin.setOnClickListener(this);

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

        if (view == btn_signup) {

            if (et_email.getText().toString().trim().length() == 0) {

                Snackbar snackbar = Snackbar
                        .make(btn_signup, "Enter Email", Snackbar.LENGTH_LONG)
                        .setAction("Email", new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {

                            }
                        });

                snackbar.show();
            } else {

                if (et_email.getText().toString().trim().matches(emailPattern)) {

                    if (et_password.getText().toString().trim().length() == 0) {
                        Snackbar snackbar = Snackbar
                                .make(btn_signup, "Enter Password", Snackbar.LENGTH_LONG)
                                .setAction("Password", new View.OnClickListener() {
                                    @Override
                                    public void onClick(View view) {
                                    }
                                });

                        snackbar.show();
//                    } else if (et_password.getText().toString().trim().length() < 6) {
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
                                    .make(btn_signup, "No Internet Connection Found", Snackbar.LENGTH_LONG)
                                    .setAction("", new View.OnClickListener() {
                                        @Override
                                        public void onClick(View view) {
                                        }
                                    });

                            snackbar1.show();

                        } else {
//
                            Signup();

                        }

                    }

                } else {
                    Snackbar snackbar = Snackbar
                            .make(btn_signup, "Enter Valid Email", Snackbar.LENGTH_LONG)
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


    private void Signup() {

        pd = new ProgressDialog(getActivity());
        pd.setMessage("loading...");
        pd.setCancelable(false);
        pd.show();

        strEmail = et_email.getText().toString().trim();
        strPassword = et_password.getText().toString().trim();


        StringRequest stringRequest = new StringRequest(Request.Method.POST, Constant.URL_REGISTER,
                new Response.Listener<String>() {

                    @Override
                    public void onResponse(String response) {
                        Log.e("res>", response);

                        pd.dismiss();

                        try {

                            JSONObject jsonObject = new JSONObject(response);

                            if (jsonObject.getBoolean("status") == true) {

                                String user_id, supplier_id, user_type, email, is_active;

                                JSONObject jsonObject1 = jsonObject.getJSONObject("data");

                                user_id = jsonObject1.getString(Constant.KEY_ID);
                                supplier_id = jsonObject1.getString(Constant.KEY_VENDER_ID);
                                user_type = jsonObject1.getString(Constant.KEY_USER_TYPE);
                                email = jsonObject1.getString(Constant.KEY_EMAIL);
                                is_active = jsonObject1.getString(Constant.KEY_IS_ACTIVE);

                                session.Signup(user_id, supplier_id, user_type, email, is_active);

                                et_email.setText("");
                                et_password.setText("");

                                Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_SHORT).show();

                            Fragment fragment = new VerifyOtpFragment();
                            FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
                            ft.replace(R.id.container, fragment);
                            ft.addToBackStack(null);
                            ft.commit();


                            } else {

                                Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_SHORT).show();

                            }

                        } catch (JSONException e) {
                            Log.e("EXCEPTION", String.valueOf(e));
                            Snackbar.make(btn_signup, e.toString(), Snackbar.LENGTH_LONG).show();
                        }

                    }

                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {

                        pd.dismiss();

                        Snackbar.make(btn_signup, error.toString(), Snackbar.LENGTH_LONG).show();
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
                map1.put(Constant.KEY_PASSWORD, strPassword);
                map1.put(Constant.KEY_DEVICE_ID, device_id);
                map1.put(Constant.KEY_USER_TYPE, Constant.signup_as);
                map1.put(Constant.KEY_DEVICE_TYPE, "android");

                Log.e("TOKEN", String.valueOf(map1));

                return map1;

            }
        };


        RequestQueue requestQueue = Volley.newRequestQueue(getActivity());
        requestQueue.add(stringRequest);

    }


}


