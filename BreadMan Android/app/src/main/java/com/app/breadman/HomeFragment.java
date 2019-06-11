package com.app.breadman;


import android.app.ProgressDialog;
import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.v4.app.Fragment;
import android.support.v4.view.GravityCompat;
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

public class HomeFragment extends Fragment implements View.OnClickListener {

    private View v;
    private SessionManagement session;
    private HashMap<String, String> user;

//    private Button btn_change;
//    private EditText et_old_password, et_new_password, et_confirm_password;
//
//    private ProgressDialog pd;
//    private String strOldPassword, strNewPassword;
//
    private String str_userid;
    private String str_email;

    private TextView title;
    private ImageView img_setting;
    private ImageView img_menu;



    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_home, container, false);

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

        img_menu = getActivity().findViewById(R.id.img_menu);
        img_menu.setImageResource(R.drawable.menu);

        img_setting = getActivity().findViewById(R.id.img_setting);
        img_setting.setVisibility(View.GONE);

        title = getActivity().findViewById(R.id.title);
        title.setText("Home");

//        et_old_password = v.findViewById(R.id.et_old_password);
//        et_new_password = v.findViewById(R.id.et_new_password);
//        et_confirm_password = v.findViewById(R.id.et_confirm_password);
//
//        btn_change = v.findViewById(R.id.btn_change);

    }

    private void listeners() {

        img_menu.setOnClickListener(this);

    }


    @Override
    public void onClick(View view) {

        Constant.hideKeyboard(getActivity());

        if (view == img_menu) {

            if (MainActivity.drawer.isDrawerOpen(GravityCompat.START)) {
                MainActivity.drawer.closeDrawer(GravityCompat.START);
//                    NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
//                    navigationView.setNavigationItemSelectedListener(MainActivity.this);

            } else {
                MainActivity.drawer.openDrawer(GravityCompat.START);
//                    NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
//                    navigationView.setNavigationItemSelectedListener(MainActivity.this);
            }

        }
    }


}


