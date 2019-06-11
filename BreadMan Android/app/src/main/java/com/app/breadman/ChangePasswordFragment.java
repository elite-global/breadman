package com.app.breadman;


import android.app.ProgressDialog;
import android.os.Bundle;
import android.provider.Settings;
import android.support.design.widget.Snackbar;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
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

public class ChangePasswordFragment extends Fragment implements View.OnClickListener {

    private View v;
    private SessionManagement session;
    private HashMap<String, String> user;

    private Button btn_change;
    private EditText et_old_password, et_new_password, et_confirm_password;

    private ProgressDialog pd;
    private String strOldPassword, strNewPassword;

    private String str_userid;
    private String str_email;

    private TextView title;
    private ImageView img_setting;
    private ImageView img_menu;

    private String str_userType;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_change_password, container, false);

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
        str_userType = user.get(SessionManagement.KEY_USER_TYPE);


        init();
        listeners();

    }

    private void init() {

        img_menu = getActivity().findViewById(R.id.img_menu);
        img_menu.setImageResource(R.drawable.back);

        img_setting = getActivity().findViewById(R.id.img_setting);
        img_setting.setVisibility(View.GONE);

        title = getActivity().findViewById(R.id.title);
        title.setText("Change Password");

        et_old_password = v.findViewById(R.id.et_old_password);
        et_new_password = v.findViewById(R.id.et_new_password);
        et_confirm_password = v.findViewById(R.id.et_confirm_password);

        btn_change = v.findViewById(R.id.btn_change);

    }

    private void listeners() {

        img_menu.setOnClickListener(this);
        btn_change.setOnClickListener(this);

    }


    @Override
    public void onClick(View view) {

        Constant.hideKeyboard(getActivity());

        if (view == img_menu) {


        FragmentManager fm = getFragmentManager();
        if (fm.getBackStackEntryCount() > 0) {

            Log.e("MainActivity", "popping backstack");
            fm.popBackStack();

        } else {

            Log.e("MainActivity", "nothing on backstack, calling super");

//            super.onBackPressed();
//            finishAffinity();

        }

//            if ("customer".equalsIgnoreCase(str_userType)) {
//
//                Fragment fragment = new ProfileCustomerFragment();
//                FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
//            ft.replace(R.id.container_main, fragment);
//            ft.addToBackStack(null);
            //                ft.commit();
//
//
//            } else {
//
//                Fragment fragment = new ProfileSupplierFragment();
//                FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
//            ft.replace(R.id.container_main, fragment);
//            ft.addToBackStack(null);
            //                ft.commit();
//
//            }

        }

        if (view == btn_change) {

            if (et_old_password.getText().toString().trim().length() == 0) {

                Snackbar snackbar = Snackbar
                        .make(btn_change, "Enter old password", Snackbar.LENGTH_LONG)
                        .setAction("Old Password", new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {

                            }
                        });

                snackbar.show();
            } else if (et_new_password.getText().toString().trim().length() == 0) {

                Snackbar snackbar = Snackbar
                        .make(btn_change, "Enter new password", Snackbar.LENGTH_LONG)
                        .setAction("New Password", new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {

                            }
                        });

                snackbar.show();

            }else if (!et_confirm_password.getText().toString().trim().equalsIgnoreCase(et_new_password.getText().toString().trim())) {

                Snackbar snackbar = Snackbar
                        .make(btn_change, "Password mismatched", Snackbar.LENGTH_LONG)
                        .setAction("Confirm Password", new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {

                            }
                        });

                snackbar.show();

            }else {

                if (Constant.isConnected(getActivity()) == false) {
                    Snackbar snackbar1 = Snackbar
                            .make(btn_change, "No Internet Connection Found", Snackbar.LENGTH_LONG)
                            .setAction("", new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                }
                            });

                    snackbar1.show();

                } else {

                    Change();

                }

            }


        }

    }


    private void Change() {

        pd = new ProgressDialog(getActivity());
        pd.setMessage("loading...");
        pd.setCancelable(false);
        pd.show();

        strOldPassword = et_old_password.getText().toString().trim();
        strNewPassword = et_new_password.getText().toString().trim();


        StringRequest stringRequest = new StringRequest(Request.Method.POST, Constant.URL_CHANGE_PASSWORD,
                new Response.Listener<String>() {

                    @Override
                    public void onResponse(String response) {
                        Log.e("res>", response);

                        pd.dismiss();

                        try {

                            JSONObject jsonObject = new JSONObject(response);

                            if (jsonObject.getBoolean("status") == true) {

                                Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_SHORT).show();

                                Fragment fragment = new HomeFragment();
                                FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
                                ft.replace(R.id.container_main, fragment);
                                ft.addToBackStack(null);
                                ft.commit();

                            } else {

                                Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_SHORT).show();

                            }

                        } catch (JSONException e) {
                            Log.e("EXCEPTION", String.valueOf(e));
                            Snackbar.make(btn_change, e.toString(), Snackbar.LENGTH_LONG).show();
                        }

                    }

                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {

                        pd.dismiss();

                        Snackbar.make(btn_change, error.toString(), Snackbar.LENGTH_LONG).show();
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
                map1.put(Constant.KEY_NEW_PASSWORD, strNewPassword);
                map1.put(Constant.KEY_OLD_PASSWORD, strOldPassword);


                Log.e("TOKEN", String.valueOf(map1));

                return map1;

            }
        };


        RequestQueue requestQueue = Volley.newRequestQueue(getActivity());
        requestQueue.add(stringRequest);

    }



}


