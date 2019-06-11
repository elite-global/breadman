package com.app.breadman;

import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.app.breadman.util.Constant;
import com.app.breadman.util.SessionManagement;

import java.util.HashMap;


public class ContactUsFragment extends Fragment implements View.OnClickListener{

    private View v,dialog_view;
    private SessionManagement session;
    private HashMap<String, String> user;

    private TextView title;
    private ImageView img_setting;
    private ImageView img_menu;

    private EditText et_subject;
    private EditText et_description;
    private Button btn_send;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v= inflater.inflate(R.layout.fragment_contact_us, container, false);

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

        title = getActivity().findViewById(R.id.title);
        title.setText("Contact Us");

        et_subject = v.findViewById(R.id.et_subject);
        et_description = v.findViewById(R.id.et_description);

        btn_send = v.findViewById(R.id.btn_send);

    }

    private void listeners() {

        btn_send.setOnClickListener(this);

    }

    @Override
    public void onClick(View view) {

        Constant.hideKeyboard(getActivity());

        if (view == btn_send) {

            if (et_subject.getText().toString().trim().length() == 0) {
                Snackbar snackbar = Snackbar
                        .make(btn_send, "Enter subject", Snackbar.LENGTH_LONG)
                        .setAction("Subject", new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {
                            }
                        });

                snackbar.show();

            }else if (et_description.getText().toString().trim().length() == 0) {
                Snackbar snackbar = Snackbar
                        .make(btn_send, "Enter description", Snackbar.LENGTH_LONG)
                        .setAction("Description", new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {
                            }
                        });

                snackbar.show();

            }else {

                try{

//                    Intent intent = new Intent (Intent.ACTION_VIEW , Uri.parse("mailto:" + "your_email"));
                    Intent intent = new Intent (Intent.ACTION_VIEW , Uri.parse("mailto:" + ""));
                    intent.putExtra(Intent.EXTRA_SUBJECT, et_subject.getText().toString().trim());
                    intent.putExtra(Intent.EXTRA_TEXT, et_description.getText().toString().trim());
                    startActivity(intent);

                }catch(ActivityNotFoundException e){
                    //TODO smth
                }
            }
        }
    }

}


