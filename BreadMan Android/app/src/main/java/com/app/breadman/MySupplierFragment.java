package com.app.breadman;


import android.Manifest;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.content.ContextCompat;
import android.support.v4.content.FileProvider;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.app.breadman.retrofit.ApiClient;
import com.app.breadman.util.Constant;
import com.app.breadman.util.SessionManagement;
import com.bumptech.glide.Glide;
import com.bumptech.glide.request.RequestOptions;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import de.hdodenhof.circleimageview.CircleImageView;
import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import retrofit2.Call;
import retrofit2.Callback;

import static android.Manifest.permission.READ_EXTERNAL_STORAGE;

public class MySupplierFragment extends Fragment implements View.OnClickListener {

    private View v,dialog_view;
    private SessionManagement session;
    private HashMap<String, String> user;


    private Button btn_remove;
    private CircleImageView img;

    private TextView title;
    private ImageView img_setting;
    private ImageView img_menu;

    private TextView tv_supplier_id;
    private TextView tv_name;
    private TextView tv_email;
    private TextView tv_mobile;
    private TextView tv_address;
    private TextView tv_rate;
    private TextView tv_daily_average;

    private String str_supplier_id;
    private String str_name;
    private String str_email;
    private String str_mobile;
    private String str_address;
    private String str_rate;
    private String str_daily_average;

    private String str_userid;

    private FloatingActionButton fab;

    private Button btn_add;
    private EditText et_supplier_id;

    private LinearLayout li_no_supplier;
    private LinearLayout li_yes_supplier;

    private ProgressDialog pd;
    private Dialog choosedialog;
    private AlertDialog.Builder builder;
    private LayoutInflater dialog_inflater;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_my_supplier, container, false);

        return v;
    }

    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        this.v = view;

        session = new SessionManagement(getActivity());
        user = session.getUserDetails();

        str_userid = user.get(SessionManagement.KEY_USER_ID);
//        str_fname = user.get(SessionManagement.KEY_FNAME);
//        str_lname = user.get(SessionManagement.KEY_LNAME);
//        str_mobile = user.get(SessionManagement.KEY_PHONE);
//        str_email = user.get(SessionManagement.KEY_EMAIL);
//        str_address = user.get(SessionManagement.KEY_ADDRESS);
//        str_image = user.get(SessionManagement.KEY_PROFILE);


        init();
        listeners();


        SetData();

    }

    private void SetData() {

        li_no_supplier.setVisibility(View.VISIBLE);
        li_yes_supplier.setVisibility(View.GONE);

//        et_fname.setText(str_fname);
//        et_lname.setText(str_lname);
//        et_email.setText(str_email);
//        et_mobile.setText(str_mobile);
//        et_address.setText(str_address);
//
//        if(str_image != null){
//
//            Glide.with(getActivity())
//                    .load(str_image)
//                    .apply(new RequestOptions().override(200, 100))
//                    .error(R.drawable.profile_pic)
//                    .into(img_user);
//
//        }

    }

    private void init() {

        img_menu = getActivity().findViewById(R.id.img_menu);
        img_menu.setImageResource(R.drawable.menu);

        img_setting = getActivity().findViewById(R.id.img_setting);
        img_setting.setVisibility(View.GONE);

        title = getActivity().findViewById(R.id.title);
        title.setText("My Supplier");

        img = v.findViewById(R.id.img);

        li_no_supplier = v.findViewById(R.id.li_no_supplier);
        li_yes_supplier = v.findViewById(R.id.li_yes_supplier);

        tv_supplier_id = v.findViewById(R.id.tv_supplier_id);
        tv_name = v.findViewById(R.id.tv_name);
        tv_email = v.findViewById(R.id.tv_email);
        tv_mobile = v.findViewById(R.id.tv_mobile);
        tv_address = v.findViewById(R.id.tv_address);
        tv_rate = v.findViewById(R.id.tv_rate);
        tv_daily_average = v.findViewById(R.id.tv_daily_average);

        fab = v.findViewById(R.id.fab);
        btn_remove = v.findViewById(R.id.btn_remove);

    }

    private void listeners() {

        fab.setOnClickListener(this);
        btn_remove.setOnClickListener(this);

    }

    @Override
    public void onClick(View view) {

        Constant.hideKeyboard(getActivity());

        if (view == fab) {

           addSupplier();

        }

        if (view == btn_remove) {

            li_no_supplier.setVisibility(View.VISIBLE);
            li_yes_supplier.setVisibility(View.GONE);

            // remove api

        }

    }

    private void addSupplier() {

        builder = new AlertDialog.Builder(getActivity());
        builder.setCancelable(true);
        dialog_inflater = (this).getLayoutInflater();
        dialog_view = dialog_inflater.inflate(R.layout.dialog_add_supplier, null);

        et_supplier_id = dialog_view.findViewById(R.id.et_supplier_id);
        btn_add = dialog_view.findViewById(R.id.btn_add);

        btn_add.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                choosedialog.dismiss();


                String dummy = et_supplier_id.getText().toString().trim();

                dummy = dummy.replaceAll("\\W+","");

                Log.e("onClick: ", dummy);

                if(dummy.trim().length() == 0){
                    Snackbar snackbar = Snackbar
                            .make(btn_add, "Enter supplier id", Snackbar.LENGTH_LONG)
                            .setAction("Supplier id", new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                }
                            });

                    snackbar.show();

                }else if(dummy.trim().length() == 6){

                    // add supplier API

//                    AddSupplier();

                    li_no_supplier.setVisibility(View.GONE);
                    li_yes_supplier.setVisibility(View.VISIBLE);

                }else {

                    Snackbar snackbar = Snackbar
                            .make(btn_add, "Invalid supplier id", Snackbar.LENGTH_LONG)
                            .setAction("Supplier id", new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                }
                            });

                    snackbar.show();
                }
            }
        });

        builder.setView(dialog_view);
        choosedialog = builder.create();
        choosedialog.show();

    }


    private void AddSupplier() {

        pd = new ProgressDialog(getActivity());
        pd.setMessage("loading...");
        pd.setCancelable(false);
        pd.show();

        final String supplier_id = et_supplier_id.getText().toString().trim();


        StringRequest stringRequest = new StringRequest(Request.Method.POST, Constant.URL_CONNECT_SUPPLIER,
                new Response.Listener<String>() {

                    @Override
                    public void onResponse(String response) {
                        Log.e("res>", response);

                        pd.dismiss();

                        try {

                            JSONObject jsonObject = new JSONObject(response);

                            if (jsonObject.getBoolean("status") == true) {

                                Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_SHORT).show();

                                li_no_supplier.setVisibility(View.GONE);
                                li_yes_supplier.setVisibility(View.VISIBLE);

                            } else {

                                Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_SHORT).show();

                            }

                        } catch (JSONException e) {
                            Log.e("EXCEPTION", String.valueOf(e));
                            Snackbar.make(btn_add, e.toString(), Snackbar.LENGTH_LONG).show();
                        }

                    }

                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {

                        pd.dismiss();

                        Snackbar.make(btn_add, error.toString(), Snackbar.LENGTH_LONG).show();
                    }
                }) {

            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                Map<String, String> map = new HashMap<String, String>();

                map.put("token", "");
                map.put("Content-Type", "application/x-www-form-urlencoded");

                return map;

            }

            @Override
            public Map<String, String> getParams() {
                Map<String, String> map1 = new HashMap<String, String>();

                map1.put(Constant.KEY_USER_ID, str_userid);
                map1.put(Constant.KEY_SUPPLIER_ID, supplier_id);


                Log.e("TOKEN", String.valueOf(map1));

                return map1;

            }
        };


        RequestQueue requestQueue = Volley.newRequestQueue(getActivity());
        requestQueue.add(stringRequest);

    }


}


