package com.app.breadman;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
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
import com.app.breadman.util.Constant;
import com.app.breadman.util.SessionManagement;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import de.hdodenhof.circleimageview.CircleImageView;


public class NotificationFragment extends Fragment implements View.OnClickListener {

    private View v, dialog_view;
    private SessionManagement session;
    private HashMap<String, String> user;


    private NotificationAdapter NotificationAdapter;
    private ArrayList<NotificationModel> Notification;
    private RecyclerView recyclerview;

    private ProgressDialog pd;
    private String str_user_id;

    private TextView title;
    private ImageView img_setting;
    private ImageView img_menu;

    private LinearLayout li_nodata_noti;

    private AlertDialog.Builder builder;
    private LayoutInflater dialog_inflater;
    public static Dialog choosedialog;

    private TextView tv_name;
    private TextView tv_email;
    private TextView tv_mobile;
    private TextView tv_address;

    private Button btn_accept;
    private CircleImageView img;

    private String str_name;
    private String str_email;
    private String str_mobile;
    private String str_address;

    private static String[] Name = {"Jennie", "Jennie", "Jennie", "Jennie", "Jennie", "Jennie"};


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_notification, container, false);

        return v;
    }

    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        this.v = view;

        session = new SessionManagement(getActivity());
        user = session.getUserDetails();

        str_user_id = user.get(SessionManagement.KEY_USER_ID);


        init();
        listeners();


//        if (Constant.isConnected(getActivity()) == false) {
//
//            showAlertDialog();
//
//        } else {
//
//            NotificationData();
//        }


        Notification = new ArrayList<>();

        recyclerview.setHasFixedSize(true);

        final LinearLayoutManager manager1 = new LinearLayoutManager(getActivity());
        manager1.setOrientation(LinearLayout.VERTICAL);
        recyclerview.setLayoutManager(manager1);

        for (int i = 0; i < Name.length; i++) {

            NotificationModel model = new NotificationModel();
            model.setUserName(Name[i]);

            Notification.add(model);

        }

        NotificationAdapter = new NotificationAdapter(getActivity(), Notification, NotificationFragment.this);
        recyclerview.setAdapter(NotificationAdapter);

    }

    private void init() {

        recyclerview = v.findViewById(R.id.recyclerview);
        li_nodata_noti = v.findViewById(R.id.li_nodata_noti);

        img_menu = getActivity().findViewById(R.id.img_menu);
        img_menu.setImageResource(R.drawable.menu);

        img_setting = getActivity().findViewById(R.id.img_setting);
        img_setting.setVisibility(View.GONE);

        title = getActivity().findViewById(R.id.title);
        title.setText("Notifications");

    }

    private void listeners() {


    }

    @Override
    public void onClick(View view) {


    }

    private void NotificationData() {

        pd = new ProgressDialog(getActivity());
        pd.setMessage("loading...");
        pd.setCancelable(false);
        pd.show();

        StringRequest stringRequest = new StringRequest(Request.Method.POST, Constant.URL_GET_USER_NOTIFICATION,
                new Response.Listener<String>() {

                    @Override
                    public void onResponse(String response) {

                        Log.e("responce+++", response);

                        pd.dismiss();

                        try {

                            JSONObject jsonObject = new JSONObject(response);

                            if (jsonObject.getBoolean("status") == true) {

                                JSONArray jsonArray1 = jsonObject.getJSONArray("data");
//
//                                for (int i = 0; i < jsonArray1.length(); i++) {
//
//                                    JSONObject jsonObject1 = jsonArray1.getJSONObject(i);
//
//                                    String SS_notification_date = null;
//                                    String SS_cancel_date = null;
//
//                                    String S_notification_type = jsonObject1.getString(Constant.KEY_NOTIFICATION_TYPE);
//
//                                    if ("Cancel task".equalsIgnoreCase(S_notification_type)) {
//
//                                        String S_notification_id = jsonObject1.getString(Constant.KEY_NOTIFICATIONID);
//                                        String S_user_id = jsonObject1.getString(Constant.KEY_USERID);
//                                        String S_job_id = jsonObject1.getString(Constant.KEY_JOB_ID);
//                                        String S_fname = jsonObject1.getString(Constant.KEY_FNAME);
//                                        String S_lname = jsonObject1.getString(Constant.KEY_LNAME);
//                                        String S_image = jsonObject1.getString(Constant.KEY_IMAGE);
//                                        String S_image_path = jsonObject1.getString(Constant.KEY_L_IMAGE_PATH);
//                                        String S_title = jsonObject1.getString(Constant.KEY_TITLE);
//                                        String S_description = jsonObject1.getString(Constant.KEY_DESCRIPTION);
//                                        String S_location = jsonObject1.getString(Constant.KEY_LOCATION);
//                                        String S_notification_date = jsonObject1.getString(Constant.KEY_NOTIFICATION_DATE);
//
//
//                                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
//                                        sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
//
//                                        DateFormat outputFormat = new SimpleDateFormat("dd MMM yyyy HH:mm:ss");
//
//                                        Date dates1 = null;
//                                        Date dates2 = null;
//                                        try {
//                                            dates1 = sdf.parse(S_notification_date);
//                                            dates2 = sdf.parse(S_cancel_date);
//                                        } catch (ParseException e) {
//                                            e.printStackTrace();
//                                        }
//
//                                        String text2 = outputFormat.format(dates1);
//                                        String text3 = outputFormat.format(dates2);
//
//                                        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd MMM yyyy HH:mm:ss");
//
//                                        try {
//
//                                            Date postDate2 = simpleDateFormat.parse(text2);
//                                            Date postDate3 = simpleDateFormat.parse(text3);
//                                            Date currentDate = simpleDateFormat.parse(Demo.getCurrentDate());
//
//                                            SS_notification_date = Demo.printDifference(currentDate, postDate2);
//                                            SS_cancel_date = Demo.printDifference(currentDate, postDate3);
//
//
//                                        } catch (Exception e) {
//                                            e.printStackTrace();
//                                        }
//
//
//                                        ModelNotification model = new ModelNotification();
//                                        model.setS_notification_id(S_notification_id);
//                                        model.setS_notification_type(S_notification_type);
//                                        model.setS_user_id(S_user_id);
//                                        model.setS_job_id(S_job_id);
//                                        model.setS_fname(S_fname);
//                                        model.setS_lname(S_lname);
//                                        model.setS_image(S_image);
//                                        model.setS_image_path(S_image_path);
//                                        model.setS_title(S_title);
//                                        model.setS_description(S_description);
//                                        model.setS_location(S_location);
//                                        model.setS_notification_date(SS_notification_date);
//
//                                        model.setS_cancel_userid(S_cancel_userid);
//                                        model.setS_cancel_fname(S_cancel_fname);
//                                        model.setS_cancel_lname(S_cancel_lname);
//                                        model.setS_cancel_image_path(S_cancel_image_path);
//                                        model.setS_cancel_date(SS_cancel_date);
//                                        model.setS_cancel_date_original(S_cancel_date);
//                                        model.setS_cancel_id(S_cancel_id);
//                                        model.setS_cancel_reason(S_cancel_reason);
//                                        model.setS_cancel_comment(S_cancel_comment);
//
//                                        Log.e("SS_cancel_dat++", S_cancel_fname);
//                                        Log.e("SS_cancel_dat++", SS_cancel_date);
//
//                                        Notification.add(0, model);
//
//
//                                    } else {
//
//                                        String S_notification_id = jsonObject1.getString(Constant.KEY_NOTIFICATIONID);
//                                        String S_user_id = jsonObject1.getString(Constant.KEY_USERID);
//                                        String S_job_id = jsonObject1.getString(Constant.KEY_JOB_ID);
//                                        String S_fname = jsonObject1.getString(Constant.KEY_FNAME);
//                                        String S_lname = jsonObject1.getString(Constant.KEY_LNAME);
//                                        String S_image = jsonObject1.getString(Constant.KEY_IMAGE);
//                                        String S_image_path = jsonObject1.getString(Constant.KEY_L_IMAGE_PATH);
//                                        String S_title = jsonObject1.getString(Constant.KEY_TITLE);
//                                        String S_description = jsonObject1.getString(Constant.KEY_DESCRIPTION);
//                                        String S_location = jsonObject1.getString(Constant.KEY_LOCATION);
//                                        String S_notification_date = jsonObject1.getString(Constant.KEY_NOTIFICATION_DATE);
//
//
//                                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
//                                        sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
//
//                                        DateFormat outputFormat = new SimpleDateFormat("dd MMM yyyy HH:mm:ss");
//
//                                        Date dates1 = null;
//                                        try {
//                                            dates1 = sdf.parse(S_notification_date);
//                                        } catch (ParseException e) {
//                                            e.printStackTrace();
//                                        }
//
//                                        String text2 = outputFormat.format(dates1);
//
//                                        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd MMM yyyy HH:mm:ss");
//
//                                        try {
//
//                                            Date postDate2 = simpleDateFormat.parse(text2);
//                                            Date currentDate = simpleDateFormat.parse(Demo.getCurrentDate());
//
//                                            SS_notification_date = Demo.printDifference(currentDate, postDate2);
//
//                                        } catch (Exception e) {
//                                            e.printStackTrace();
//                                        }
//
//
//                                        NotificationModel model = new NotificationModel();
//                                        model.setS_notification_id(S_notification_id);
//                                        model.setS_notification_type(S_notification_type);
//                                        model.setS_user_id(S_user_id);
//                                        model.setS_job_id(S_job_id);
//                                        model.setS_fname(S_fname);
//                                        model.setS_lname(S_lname);
//                                        model.setS_image(S_image);
//                                        model.setS_image_path(S_image_path);
//                                        model.setS_title(S_title);
//                                        model.setS_description(S_description);
//                                        model.setS_location(S_location);
//                                        model.setS_notification_date(SS_notification_date);
//
//                                        Notification.add(0, model);
//
//                                    }
//
//                                }

                                Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_SHORT).show();


                            } else {

                                Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_SHORT).show();

                            }

                            if (Notification.size() == 0) {

                                li_nodata_noti.setVisibility(View.VISIBLE);
                                recyclerview.setVisibility(View.GONE);

                            } else {

                                li_nodata_noti.setVisibility(View.GONE);
                                recyclerview.setVisibility(View.VISIBLE);

                                NotificationAdapter = new NotificationAdapter(getActivity(), Notification, NotificationFragment.this);
                                recyclerview.setAdapter(NotificationAdapter);
                            }


                        } catch (JSONException e) {
                            Snackbar.make(btn_accept, e.toString(), Snackbar.LENGTH_LONG).show();

                            Log.e("intent11", e.toString());

                        }

                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {

                        pd.dismiss();

                        Log.e("intent22", error.toString());

                        Snackbar.make(btn_accept, error.toString(), Snackbar.LENGTH_LONG).show();
                    }
                }) {

            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                Map<String, String> map = new HashMap<String, String>();

                map.put("Content-Type", "application/x-www-form-urlencoded");
                map.put("token", "");

                return map;

            }

            @Override
            protected Map<String, String> getParams() {
                Map<String, String> map1 = new HashMap<String, String>();

                map1.put(Constant.KEY_USER_ID, str_user_id);

                Log.e("map1", String.valueOf(map1));

                return map1;
            }
        };

        RequestQueue requestQueue = Volley.newRequestQueue(getActivity());
        requestQueue.add(stringRequest);


    }


//    private void ConfirmCancelRequest(final String cancel_id, final String reason) {
//
//        pd = new ProgressDialog(getActivity());
//        pd.setMessage("loading...");
//        pd.setCancelable(false);
//        pd.show();
//
//
//        StringRequest stringRequest = new StringRequest(Request.Method.POST, Constant.URL_CONFIRM_CANCEL_JOB_REQUEST,
//                new Response.Listener<String>() {
//
//                    @Override
//                    public void onResponse(String response) {
//
//                        Log.e("responce+++", response);
//
//                        pd.dismiss();
//
//                        try {
//
//                            JSONObject jsonObjectr = new JSONObject(response);
//
//
//                            if (jsonObjectr.getBoolean("status") == true) {
//
//                                Toast.makeText(getActivity(), jsonObjectr.getString("message"), Toast.LENGTH_SHORT).show();
//
//                                ThankyouDialog();
//
//                            } else {
//
//                                Toast.makeText(getActivity(), jsonObjectr.getString("message"), Toast.LENGTH_SHORT).show();
//
//                            }
//
//
//                        } catch (JSONException e) {
//
//                            Snackbar.make(back_icon, e.toString(), Snackbar.LENGTH_LONG).show();
//
//                            Log.e("intent11", e.toString());
//
//                        }
//
//                    }
//                },
//                new Response.ErrorListener() {
//                    @Override
//                    public void onErrorResponse(VolleyError error) {
//
//                        pd.dismiss();
//
//                        Log.e("intent22", error.toString());
//
//                        Snackbar.make(back_icon, error.toString(), Snackbar.LENGTH_LONG).show();
//                    }
//                }) {
//
//            @Override
//            public Map<String, String> getHeaders() throws AuthFailureError {
//                Map<String, String> map = new HashMap<String, String>();
//
//
//                map.put("Content-Type", "application/x-www-form-urlencoded");
//                map.put("token", str_token);
//
//                Log.e("TOKEN", str_token);
//
//                return map;
//
//            }
//
//            @Override
//            protected Map<String, String> getParams() {
//                Map<String, String> map1 = new HashMap<String, String>();
//
//                map1.put(Constant.KEY_USERID, str_user_id);
//                map1.put(Constant.KEY_CANCEL_ID, cancel_id);
//                map1.put(Constant.KEY_CANCEL_REASON, reason);
//
//                Log.e("map1", String.valueOf(map1));
//
//                return map1;
//            }
//        };
//
//        RequestQueue requestQueue = Volley.newRequestQueue(getActivity());
//        requestQueue.add(stringRequest);
//
//
//    }

    public void showAlertDialog() {

        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        builder.setCancelable(false);
        builder.setTitle("No Internet Available");

        builder.setPositiveButton(
                "Try again",
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {

                        choosedialog.dismiss();

                        if (Constant.isConnected(getActivity()) == false) {

                            // call function show alert dialog again
                            showAlertDialog();

                        } else {

                            NotificationData();

                        }
                    }
                });


        Dialog choosedialog = builder.create();
        choosedialog.show();

    }

    public void AddRequestDialog() {

        builder = new AlertDialog.Builder(getActivity());
        builder.setCancelable(true);
        dialog_inflater = (this).getLayoutInflater();
        dialog_view = dialog_inflater.inflate(R.layout.dialog_accept_customer_request, null);

        img = dialog_view.findViewById(R.id.img);
        tv_name = dialog_view.findViewById(R.id.tv_name);
        tv_email = dialog_view.findViewById(R.id.tv_email);
        tv_mobile = dialog_view.findViewById(R.id.tv_mobile);
        tv_address = dialog_view.findViewById(R.id.tv_address);

        btn_accept = dialog_view.findViewById(R.id.btn_accept);

        btn_accept.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                choosedialog.dismiss();

                // accept api

            }
        });

        builder.setView(dialog_view);
        choosedialog = builder.create();
        choosedialog.show();

    }

}


