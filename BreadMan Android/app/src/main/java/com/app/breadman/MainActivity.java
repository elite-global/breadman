package com.app.breadman;

import android.content.DialogInterface;
import android.os.Bundle;
import android.support.design.widget.NavigationView;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.view.GravityCompat;
import android.support.v4.view.ViewPager;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.app.breadman.util.Constant;
import com.app.breadman.util.SessionManagement;
import com.bumptech.glide.Glide;
import com.bumptech.glide.request.RequestOptions;

import java.util.HashMap;

import de.hdodenhof.circleimageview.CircleImageView;


public class MainActivity extends AppCompatActivity implements View.OnClickListener {

    private SessionManagement session;
    private HashMap<String, String> user;

    FragmentTransaction transaction;
    FragmentManager manager;
    static FragmentManager fragmentManager;
    NavigationView navigationView;
    Toolbar toolbar;
    public static DrawerLayout drawer;
    ImageView img_menu;

    CircleImageView img_user;
    TextView tv_name;
    private String str_fname;
    private String str_lname;
    private String str_image;

    LinearLayout li_item0;
    LinearLayout li_item1;
    LinearLayout li_item2;
    LinearLayout li_item3;
    LinearLayout li_item4;
    LinearLayout li_item5;
    LinearLayout li_item6;
    LinearLayout li_item7;
    LinearLayout li_item8;
    LinearLayout li_item9;
    LinearLayout li_item10;
    LinearLayout li_item11;

    String str_userType;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        session = new SessionManagement(this);
        user = session.getUserDetails();

        str_userType = user.get(SessionManagement.KEY_USER_TYPE);
        str_fname = user.get(SessionManagement.KEY_FNAME);
        str_lname = user.get(SessionManagement.KEY_LNAME);
        str_image = user.get(SessionManagement.KEY_PROFILE);

        init();
        listeners();


        if ("customer".equalsIgnoreCase(str_userType)) {

            li_item1.setVisibility(View.VISIBLE);
            li_item2.setVisibility(View.VISIBLE);
            li_item3.setVisibility(View.VISIBLE);
            li_item11.setVisibility(View.VISIBLE);

            li_item7.setVisibility(View.GONE);
            li_item8.setVisibility(View.GONE);
            li_item9.setVisibility(View.GONE);
            li_item10.setVisibility(View.GONE);

        } else {

            li_item1.setVisibility(View.GONE);
            li_item2.setVisibility(View.GONE);
            li_item3.setVisibility(View.GONE);
            li_item11.setVisibility(View.GONE);

            li_item7.setVisibility(View.VISIBLE);
            li_item8.setVisibility(View.VISIBLE);
            li_item9.setVisibility(View.VISIBLE);
            li_item10.setVisibility(View.VISIBLE);

        }


        Fragment fragment = new HomeFragment();
        FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
        ft.replace(R.id.container_main, fragment);
        ft.addToBackStack(null);
        ft.commit();

    }

    private void init() {

        img_menu = findViewById(R.id.img_menu);
        drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        navigationView = (NavigationView) findViewById(R.id.nav_view);

//        toolbar = (Toolbar) findViewById(R.id.toolbar);
//        setSupportActionBar(toolbar);

        manager = getSupportFragmentManager();
        fragmentManager = getSupportFragmentManager();

        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.setDrawerListener(toggle);
        toggle.syncState();


        img_user = findViewById(R.id.img_user);
        tv_name = findViewById(R.id.tv_name);

        if(str_fname == null && str_lname == null) {

            tv_name.setText("User name");

        }else{

            tv_name.setText(str_fname + " " + str_lname);

        }

        if (str_image != null) {

            Glide.with(this)
                    .load(str_image)
                    .apply(new RequestOptions().override(200, 100))
                    .error(R.drawable.profile_pic)
                    .into(img_user);

        }

        li_item0 = (LinearLayout) findViewById(R.id.li_item0);
        li_item1 = (LinearLayout) findViewById(R.id.li_item1);
        li_item2 = (LinearLayout) findViewById(R.id.li_item2);
        li_item3 = (LinearLayout) findViewById(R.id.li_item3);
        li_item4 = (LinearLayout) findViewById(R.id.li_item4);
        li_item5 = (LinearLayout) findViewById(R.id.li_item5);
        li_item6 = (LinearLayout) findViewById(R.id.li_item6);
        li_item7 = (LinearLayout) findViewById(R.id.li_item7);
        li_item8 = (LinearLayout) findViewById(R.id.li_item8);
        li_item9 = (LinearLayout) findViewById(R.id.li_item9);
        li_item10 = (LinearLayout) findViewById(R.id.li_item10);
        li_item11 = (LinearLayout) findViewById(R.id.li_item11);


    }

    private void listeners() {

        img_menu.setOnClickListener(this);
        img_user.setOnClickListener(this);

        li_item0.setOnClickListener(this);
        li_item1.setOnClickListener(this);
        li_item2.setOnClickListener(this);
        li_item3.setOnClickListener(this);
        li_item4.setOnClickListener(this);
        li_item5.setOnClickListener(this);
        li_item6.setOnClickListener(this);
        li_item7.setOnClickListener(this);
        li_item8.setOnClickListener(this);
        li_item9.setOnClickListener(this);
        li_item10.setOnClickListener(this);
        li_item11.setOnClickListener(this);

    }


    @Override
    public void onClick(View v) {

        if (v == img_menu) {

            if (drawer.isDrawerOpen(GravityCompat.START)) {
                drawer.closeDrawer(GravityCompat.START);
//                    NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
//                    navigationView.setNavigationItemSelectedListener(MainActivity.this);

            } else {
                drawer.openDrawer(GravityCompat.START);
//                    NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
//                    navigationView.setNavigationItemSelectedListener(MainActivity.this);
            }

        }

        if (v == img_user) {

            drawer.closeDrawer(GravityCompat.START);

            if ("customer".equalsIgnoreCase(str_userType)) {

                Fragment fragment = new ProfileCustomerFragment();
                FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
                ft.replace(R.id.container_main, fragment);
                ft.addToBackStack(null);
                ft.commit();

            } else {

                Fragment fragment = new ProfileSupplierFragment();
                FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
                ft.replace(R.id.container_main, fragment);
                ft.addToBackStack(null);
                ft.commit();

            }

        }

        if (v == li_item0) {

            drawer.closeDrawer(GravityCompat.START);

            Fragment fragment = new HomeFragment();
            FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
            ft.replace(R.id.container_main, fragment);
            ft.addToBackStack(null);
            ft.commit();

            Toast.makeText(this, "home", Toast.LENGTH_SHORT).show();
        }

        if (v == li_item1) {

            drawer.closeDrawer(GravityCompat.START);

            Fragment fragment = new MySupplierFragment();
            FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
            ft.replace(R.id.container_main, fragment);
            ft.addToBackStack(null);
            ft.commit();

            Toast.makeText(this, "my supplier", Toast.LENGTH_SHORT).show();
        }

        if (v == li_item2) {

            drawer.closeDrawer(GravityCompat.START);

            Toast.makeText(this, "my orders", Toast.LENGTH_SHORT).show();

        }

        if (v == li_item3) {

            drawer.closeDrawer(GravityCompat.START);

            Toast.makeText(this, "received orders", Toast.LENGTH_SHORT).show();

        }

        if (v == li_item4) {

            drawer.closeDrawer(GravityCompat.START);

            Fragment fragment = new AboutUsFragment();
            FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
            ft.replace(R.id.container_main, fragment);
            ft.addToBackStack(null);
            ft.commit();

            Toast.makeText(this, "about us", Toast.LENGTH_SHORT).show();

        }

        if (v == li_item5) {

            drawer.closeDrawer(GravityCompat.START);

            Fragment fragment = new ContactUsFragment();
            FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
            ft.replace(R.id.container_main, fragment);
            ft.addToBackStack(null);
            ft.commit();

            Toast.makeText(this, "contact us", Toast.LENGTH_SHORT).show();

        }

        if (v == li_item6) {

            drawer.closeDrawer(GravityCompat.START);

            showLogoutDialog();

        }

        if (v == li_item7) {

            drawer.closeDrawer(GravityCompat.START);

            Toast.makeText(this, "my customers", Toast.LENGTH_SHORT).show();

        }

        if (v == li_item8) {

            drawer.closeDrawer(GravityCompat.START);

            Toast.makeText(this, "pending requests", Toast.LENGTH_SHORT).show();

        }

        if (v == li_item9) {

            drawer.closeDrawer(GravityCompat.START);

            Toast.makeText(this, "pending orders", Toast.LENGTH_SHORT).show();

        }

        if (v == li_item10) {

            drawer.closeDrawer(GravityCompat.START);

            Toast.makeText(this, "delivered orders", Toast.LENGTH_SHORT).show();

        }

        if (v == li_item11) {

            drawer.closeDrawer(GravityCompat.START);

            Fragment fragment = new NotificationFragment();
            FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
            ft.replace(R.id.container_main, fragment);
            ft.addToBackStack(null);
            ft.commit();

            Toast.makeText(this, "notification", Toast.LENGTH_SHORT).show();

        }

    }

    private void showLogoutDialog() {

        android.support.v7.app.AlertDialog.Builder builder1 = new android.support.v7.app.AlertDialog.Builder(MainActivity.this, R.style.AlertDialogTheme);
        builder1.setTitle("SignOut");
        builder1.setMessage("Are you sure?");
        builder1.setCancelable(true);

        builder1.setPositiveButton(
                "Ok",
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {

//                        logout();

                        session.logoutUser();

                    }
                });

        builder1.setNegativeButton(
                "Cancel",
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        dialog.cancel();
                    }
                });

        android.support.v7.app.AlertDialog alert11 = builder1.create();
        alert11.show();
    }


    @Override
    public void onBackPressed() {

        android.app.FragmentManager fm = getFragmentManager();
        if (fm.getBackStackEntryCount() > 0) {

            Log.e("MainActivity", "popping backstack");
            fm.popBackStack();

        } else {

            Log.e("MainActivity", "nothing on backstack, calling super");

            super.onBackPressed();
//            finishAffinity();

        }

    }


}
