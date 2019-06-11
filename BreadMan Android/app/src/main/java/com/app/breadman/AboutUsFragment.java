package com.app.breadman;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.app.breadman.util.SessionManagement;

import java.util.ArrayList;
import java.util.HashMap;

import de.hdodenhof.circleimageview.CircleImageView;


public class AboutUsFragment extends Fragment implements View.OnClickListener{

    private View v,dialog_view;
    private SessionManagement session;
    private HashMap<String, String> user;

    private TextView tv_about;
    private TextView title;
    private ImageView img_setting;
    private ImageView img_menu;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v= inflater.inflate(R.layout.fragment_about_us, container, false);

        return v;
    }

    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        this.v = view;

        session = new SessionManagement(getActivity());
        user = session.getUserDetails();

//        str_user_id = user.get(SessionManagement.KEY_USER_ID);


        init();
        listeners();
    }

    private void init(){

        img_menu = getActivity().findViewById(R.id.img_menu);
        img_menu.setImageResource(R.drawable.menu);

        img_setting = getActivity().findViewById(R.id.img_setting);
        img_setting.setVisibility(View.GONE);

        tv_about = v.findViewById(R.id.tv_about);

        title = getActivity().findViewById(R.id.title);
        title.setText("About Us");


    }

    private void listeners() {


    }

    @Override
    public void onClick(View view) {


    }

}


