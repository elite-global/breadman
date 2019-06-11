package com.app.breadman;

import android.app.FragmentManager;
import android.content.Intent;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.AppCompatActivity;

import android.os.Bundle;
import android.util.Log;
import android.view.View;

import com.app.breadman.util.SessionManagement;


public class LoginActivity extends AppCompatActivity {

    private SessionManagement session;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        session = new SessionManagement(getApplicationContext());

        Log.e("session.LoggedIn()++++", String.valueOf(session.isLoggedIn()));

        if(session.isLoggedIn()){

            startActivity(new Intent(LoginActivity.this, MainActivity.class));
            finish();

        }else {

            setContentView(R.layout.activity_login);

            Fragment fragment = new LoginFragment();
            FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
            ft.replace(R.id.container, fragment);
            ft.addToBackStack(null);
            ft.commit();

        }

    }

    @Override
    public void onBackPressed() {

        FragmentManager fm = getFragmentManager();
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
