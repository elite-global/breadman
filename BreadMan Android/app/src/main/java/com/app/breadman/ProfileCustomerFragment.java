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
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.provider.Settings;
import android.support.design.widget.Snackbar;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.content.ContextCompat;
import android.support.v4.content.FileProvider;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.util.Base64;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
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
import com.app.breadman.retrofit.ApiClient;
import com.app.breadman.retrofit.resp;
import com.app.breadman.util.Constant;
import com.app.breadman.util.SessionManagement;
import com.bumptech.glide.Glide;
import com.bumptech.glide.request.RequestOptions;
import com.google.gson.Gson;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.google.gson.JsonObject;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Retrofit;
import retrofit2.http.Part;

import static android.Manifest.permission.READ_EXTERNAL_STORAGE;

public class ProfileCustomerFragment extends Fragment implements View.OnClickListener {

    private View v,dialog_view;
    private SessionManagement session;
    private HashMap<String, String> user;

    private Button btn_save;
    private ImageView img_edit;
    private ImageView img_user;

    private TextView title;
    private ImageView img_setting;
    private ImageView img_menu;

    private EditText et_fname;
    private EditText et_lname;
    private EditText et_email;
    private EditText et_mobile;
    private EditText et_address;

    private String str_fname;
    private String str_lname;
    private String str_email;
    private String str_mobile;
    private String str_address;
    private String str_userid;

    private String emailPattern;

    private ProgressDialog pd;

    private Dialog choosedialog;
    private AlertDialog.Builder builder;
    private LayoutInflater dialog_inflater;
    private Button gallary, camera;
    private static final int MEDIA_TYPE_IMAGE = 2;
    private static final int CAMERA_REQUEST = 8;
    public static final int MY_PERMISSIONS_REQUEST_READ_EXTERNAL_STORAGE = 123;
    private Uri uri_cameraimage;
    private String str_image;
    private String TAG = "jhghj";

    public static final String MEDIA_DIRECTORY_NAME = "BreadMan";
    public static final String IMAGE_FORMAT = ".jpg";
    public static final String IMAGE_SIGN = "IMG_";
    public static final String THUMB_SIGN = "THB_";
    public static final String TIME_STAMP_FORMAT = "yyyyMMdd_HHmmss";



    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_profile_customer, container, false);

        return v;
    }

    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        this.v = view;

        session = new SessionManagement(getActivity());
        user = session.getUserDetails();


        str_userid = user.get(SessionManagement.KEY_USER_ID);
        str_fname = user.get(SessionManagement.KEY_FNAME);
        str_lname = user.get(SessionManagement.KEY_LNAME);
        str_mobile = user.get(SessionManagement.KEY_PHONE);
        str_email = user.get(SessionManagement.KEY_EMAIL);
        str_address = user.get(SessionManagement.KEY_ADDRESS);
        str_image = user.get(SessionManagement.KEY_PROFILE);


        init();
        listeners();


        SetData();

    }

    private void SetData() {

        et_fname.setText(str_fname);
        et_lname.setText(str_lname);
        et_email.setText(str_email);
        et_mobile.setText(str_mobile);
        et_address.setText(str_address);

        if(str_image != null){

            Glide.with(getActivity())
                    .load(str_image)
                    .apply(new RequestOptions().override(200, 100))
                    .error(R.drawable.profile_pic)
                    .into(img_user);

        }

    }

    private void init() {

        emailPattern = "[a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]+";

        img_menu = getActivity().findViewById(R.id.img_menu);
        img_menu.setImageResource(R.drawable.menu);

        img_setting = getActivity().findViewById(R.id.img_setting);
        img_setting.setVisibility(View.VISIBLE);

        title = getActivity().findViewById(R.id.title);
        title.setText("Profile");

        img_edit = v.findViewById(R.id.img_edit);
        img_user = v.findViewById(R.id.img_user);

        et_fname = v.findViewById(R.id.et_fname);
        et_lname = v.findViewById(R.id.et_lname);
        et_email = v.findViewById(R.id.et_email);
        et_mobile = v.findViewById(R.id.et_mobile);
        et_address = v.findViewById(R.id.et_address);

        btn_save = v.findViewById(R.id.btn_save);

    }

    private void listeners() {

        img_edit.setOnClickListener(this);
        btn_save.setOnClickListener(this);
        img_setting.setOnClickListener(this);
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

        if (view == img_setting) {

            Fragment fragment = new ChangePasswordFragment();
            FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
            ft.replace(R.id.container_main, fragment);
            ft.addToBackStack(null);
            ft.commit();

        }

        if (view == img_edit) {

            if (checkPermissionREAD_EXTERNAL_STORAGE(getActivity()) && isStoragePermissionGranted()) {

                setUserImage();

            }
        }

        if (view == btn_save) {

//            if (str_image == null) {
//                Snackbar snackbar = Snackbar
//                        .make(btn_save, "Select profile image", Snackbar.LENGTH_LONG)
//                        .setAction("Profile image", new View.OnClickListener() {
//                            @Override
//                            public void onClick(View view) {
//                            }
//                        });
//
//                snackbar.show();
//
//            } else
                if (et_fname.getText().toString().trim().length() == 0) {
                Snackbar snackbar = Snackbar
                        .make(btn_save, "Enter first name", Snackbar.LENGTH_LONG)
                        .setAction("First Name", new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {
                            }
                        });

                snackbar.show();

            } else if (et_lname.getText().toString().trim().length() == 0) {
                Snackbar snackbar = Snackbar
                        .make(btn_save, "Enter last name", Snackbar.LENGTH_LONG)
                        .setAction("Last Name", new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {
                            }
                        });

                snackbar.show();

            } else if (et_email.getText().toString().trim().length() == 0) {

                Snackbar snackbar = Snackbar
                        .make(btn_save, "Enter email", Snackbar.LENGTH_LONG)
                        .setAction("Email", new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {

                            }
                        });

                snackbar.show();
            } else if (et_email.getText().toString().trim().matches(emailPattern)) {


                if (et_mobile.getText().toString().trim().length() == 0) {
                    Snackbar snackbar = Snackbar
                            .make(btn_save, "Enter mobile number", Snackbar.LENGTH_LONG)
                            .setAction("Mobile Number", new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                }
                            });

                    snackbar.show();

                } else if (et_address.getText().toString().trim().length() == 0) {
                    Snackbar snackbar = Snackbar
                            .make(btn_save, "Enter address", Snackbar.LENGTH_LONG)
                            .setAction("Address", new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                }
                            });

                    snackbar.show();
                } else {

                    if (Constant.isConnected(getActivity()) == false) {
                        Snackbar snackbar1 = Snackbar
                                .make(btn_save, "No Internet Connection Found", Snackbar.LENGTH_LONG)
                                .setAction("", new View.OnClickListener() {
                                    @Override
                                    public void onClick(View view) {
                                    }
                                });

                        snackbar1.show();

                    } else {

                        updateData();

                    }

                }

            } else {
                Snackbar snackbar = Snackbar
                        .make(btn_save, "Enter Valid Email", Snackbar.LENGTH_LONG)
                        .setAction("Email", new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {
                            }
                        });

                snackbar.show();

            }

        }

    }


    public static String getFileToByte(String filePath){

        Bitmap bmp = null;
        ByteArrayOutputStream bos = null;
        byte[] bt = null;
        String encodeString = null;
        try{
            bmp = BitmapFactory.decodeFile(filePath);
            bos = new ByteArrayOutputStream();
            bmp.compress(Bitmap.CompressFormat.JPEG, 100, bos);
            bt = bos.toByteArray();
            encodeString = Base64.encodeToString(bt, Base64.DEFAULT);
        }catch (Exception e){
            e.printStackTrace();
        }

        return encodeString;
    }


    private void updateData() {

        pd = new ProgressDialog(getActivity());
        pd.setMessage("loading...");
        pd.setCancelable(false);
        pd.show();

        str_fname = et_fname.getText().toString().trim();
        str_lname = et_lname.getText().toString().trim();
        str_email = et_email.getText().toString().trim();
        str_mobile = et_mobile.getText().toString().trim();
        str_address = et_address.getText().toString().trim();

        Log.e( "updateData: ", str_userid);
        Log.e( "updateData: ", str_fname);
        Log.e( "updateData: ", str_lname);
        Log.e( "updateData: ", str_email);
        Log.e( "updateData: ", str_mobile);
        Log.e( "updateData: ", str_address);
        Log.e( "updateData: ", str_image +"");

        RequestBody userid = RequestBody.create(MediaType.parse("multipart/form-data"), str_userid);
        RequestBody fname = RequestBody.create(MediaType.parse("multipart/form-data"), str_fname);
        RequestBody lname = RequestBody.create(MediaType.parse("multipart/form-data"),  str_lname);
        RequestBody email = RequestBody.create(MediaType.parse("multipart/form-data"),  str_email);
        RequestBody phone = RequestBody.create(MediaType.parse("multipart/form-data"),  str_mobile);
        RequestBody address = RequestBody.create(MediaType.parse("multipart/form-data"),  str_address);

        if(str_image != null) {
            if (str_image.startsWith("http:")) {

                str_image = null;

            } else if ("".equalsIgnoreCase(str_image)) {

                Log.e("ssss:1 ", "ssss");

                str_image = null;

            }
        }

        MultipartBody.Part imageFile = null;
        if (str_image != null) {

            File file = new File(str_image);
            Log.e("AttachmentApi: ", file.getName());

            RequestBody requestFile = RequestBody.create(MediaType.parse("multipart/form-data"), file);

            // MultipartBody.Part is used to send also the actual file name
            imageFile = MultipartBody.Part.createFormData("profile", file.getName(), requestFile);

        }else {

            RequestBody requestFile = RequestBody.create(MediaType.parse("multipart/form-data"), "");

            // MultipartBody.Part is used to send also the actual file name
            imageFile = MultipartBody.Part.createFormData("profile", "", requestFile);
        }

        Call<String> call = ApiClient.getClient().UpdateProfileCustomer(userid, fname, lname, phone, email, address, imageFile);


        call.enqueue(new Callback<String>() {
            @Override
            public void onResponse(Call<String> call, retrofit2.Response<String> response) {

                pd.dismiss();

                String atrResponse = response.body().toString();
                Log.e("resp", atrResponse);

                try {

                    JSONObject jsonObject = new JSONObject(atrResponse);

                    if (jsonObject.getBoolean("status") == true) {

                        String user_id, supplier_id, user_type, email, is_active, first_name, last_name, phone, address,
                                pincode, profile, rate_per_kg, daily_avg_quantity, is_deleted;

                        JSONObject jsonObject1 = jsonObject.getJSONObject("data");

                        user_id = jsonObject1.getString(Constant.KEY_ID);
                        supplier_id = jsonObject1.getString(Constant.KEY_VENDER_ID);
                        user_type = jsonObject1.getString(Constant.KEY_USER_TYPE);
                        email = jsonObject1.getString(Constant.KEY_EMAIL);
                        is_active = jsonObject1.getString(Constant.KEY_IS_ACTIVE);
                        first_name = jsonObject1.getString(Constant.KEY_FNAME);
                        last_name = jsonObject1.getString(Constant.KEY_LNAME);
                        phone = jsonObject1.getString(Constant.KEY_PHONE);
                        address = jsonObject1.getString(Constant.KEY_ADDRESS);
                        pincode = jsonObject1.getString(Constant.KEY_PINCODE);
                        profile = jsonObject1.getString(Constant.KEY_PROFILE);
                        rate_per_kg = jsonObject1.getString(Constant.KEY_RATE_PER_KG);
                        daily_avg_quantity = jsonObject1.getString(Constant.KEY_DAILY_AVG_QUANTITY);
                        is_deleted = jsonObject1.getString(Constant.KEY_IS_DELETED);


                        Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_SHORT).show();

                        session.Login(user_id, supplier_id, user_type, email, is_active, first_name, last_name, phone, address,
                                pincode, profile, rate_per_kg, daily_avg_quantity, is_deleted);


//                        Fragment fragment = new HomeFragment();
//                        FragmentTransaction ft = getActivity().getSupportFragmentManager().beginTransaction();
//                        ft.replace(R.id.container_main, fragment);
//                        ft.addToBackStack(null);
//                        ft.commit();

                        getActivity().finish();
                        getActivity().overridePendingTransition(0, 0);
                        startActivity(getActivity().getIntent());
                        getActivity().overridePendingTransition(0, 0);


                    } else {

                        Toast.makeText(getActivity(), jsonObject.getString("message"), Toast.LENGTH_SHORT).show();

                    }

                } catch (JSONException e) {

                    Log.e("Exception1", String.valueOf(e));

                    Snackbar.make(btn_save, e.toString(), Snackbar.LENGTH_LONG).show();

                }


            }

            @Override
            public void onFailure(Call<String> call, Throwable t) {
                Log.e("onFailure", t.toString());

                pd.dismiss();

            }


        });

    }


    private void setUserImage() {

        builder = new AlertDialog.Builder(getActivity());
        builder.setCancelable(true);
        dialog_inflater = (this).getLayoutInflater();
        dialog_view = dialog_inflater.inflate(R.layout.dialog_imagegallery, null);
        gallary = (Button) dialog_view.findViewById(R.id.gallary);
        camera = (Button) dialog_view.findViewById(R.id.camera);
        builder.setView(dialog_view);
        choosedialog = builder.create();
        choosedialog.show();

        gallary.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                choosedialog.dismiss();

                Intent opengallary = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
                startActivityForResult(Intent.createChooser(opengallary, "Open Gallary"), 5);
            }
        });

        camera.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                choosedialog.dismiss();

                Intent cameraIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
                cameraIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                uri_cameraimage = getOutputMediaFileUrir(MEDIA_TYPE_IMAGE);
                cameraIntent.putExtra(MediaStore.EXTRA_OUTPUT, uri_cameraimage); // set the image file
                startActivityForResult(cameraIntent, 6);
            }
        });

    }

    public boolean isStoragePermissionGranted() {
        if (Build.VERSION.SDK_INT >= 23) {
            if (getActivity().checkSelfPermission(android.Manifest.permission.WRITE_EXTERNAL_STORAGE)
                    == PackageManager.PERMISSION_GRANTED) {
                Log.v(TAG, "Permission is granted");
                return true;
            } else {

                Log.v(TAG, "Permission is revoked");
                ActivityCompat.requestPermissions(getActivity(), new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, 1);
                return false;
            }
        } else { //permission is automatically granted on sdk<23 upon installation
            Log.v(TAG, "Permission is granted");
            return true;
        }
    }

    private Uri getOutputMediaFileUrir(int type) {

        Uri u1 = null;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {

            u1 = FileProvider.getUriForFile(getActivity(), BuildConfig.APPLICATION_ID + ".provider", getOutputMediaFiler(type));
        } else {

            u1 = Uri.fromFile(getOutputMediaFiler(type));
        }
        return u1;

    }

    private static File getOutputMediaFiler(int type) {

        File mediaStorageDir = new File(
                Environment
                        .getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES),
                MEDIA_DIRECTORY_NAME);

        if (!mediaStorageDir.exists()) {
            if (!mediaStorageDir.mkdirs()) {
                return null;
            }
        }


        File mediaFile;
        if (type == MEDIA_TYPE_IMAGE) {
            mediaFile = new File(mediaStorageDir.getPath() + File.separator
                    + IMAGE_SIGN + getTimeStamp() + IMAGE_FORMAT);
        } else {
            return null;
        }

        return mediaFile;
    }

    private static String getTimeStamp() {
        return new SimpleDateFormat(TIME_STAMP_FORMAT,
                Locale.getDefault()).format(new Date());
    }

    public boolean checkPermissionREAD_EXTERNAL_STORAGE(
            final Context context) {
        int currentAPIVersion = Build.VERSION.SDK_INT;
        if (currentAPIVersion >= Build.VERSION_CODES.M) {
            if (ContextCompat.checkSelfPermission(context,
                    READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                if (ActivityCompat.shouldShowRequestPermissionRationale(
                        (Activity) context,
                        READ_EXTERNAL_STORAGE)) {
                    showDialog("External storage", context,
                            READ_EXTERNAL_STORAGE);

                } else {
                    ActivityCompat
                            .requestPermissions(
                                    (Activity) context,
                                    new String[]{READ_EXTERNAL_STORAGE},
                                    MY_PERMISSIONS_REQUEST_READ_EXTERNAL_STORAGE);
                }
                return false;

            } else {
                return true;

            }

        } else {
            return true;
        }
    }

    public void showDialog(final String msg, final Context context,
                           final String permission) {
        AlertDialog.Builder alertBuilder = new AlertDialog.Builder(context);
        alertBuilder.setCancelable(true);
        alertBuilder.setTitle("Permission necessary");
        alertBuilder.setMessage(msg + " permission is necessary");
        alertBuilder.setPositiveButton(android.R.string.yes,
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        ActivityCompat.requestPermissions((Activity) context,
                                new String[]{permission},
                                MY_PERMISSIONS_REQUEST_READ_EXTERNAL_STORAGE);
                    }
                });
        AlertDialog alert = alertBuilder.create();
        alert.show();
    }

    public String getPath(Uri uri) {

        Cursor cursor = getActivity().getContentResolver().query(uri, null, null, null, null);
        cursor.moveToFirst();
        String document_id = cursor.getString(0);
        document_id = document_id.substring(document_id.lastIndexOf(":") + 1);
        cursor.close();

        cursor = getActivity().getContentResolver().query(
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                null, MediaStore.Images.Media._ID + " = ? ", new String[]{document_id}, null);
        cursor.moveToFirst();

        String path = cursor.getString(cursor.getColumnIndex(MediaStore.Images.Media.DATA));

        Log.e("path", path);
        cursor.close();

        return path;
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        try {


            if (requestCode == 5 && resultCode == getActivity().RESULT_OK) {

                str_image = getPath(data.getData());
                Log.e("uri++0", String.valueOf(str_image));

                Glide.with(this)
                        .load(data.getData())
                        .error(R.drawable.profile_pic)
                        .into(img_user);
            }

            if (requestCode == 6 && resultCode == getActivity().RESULT_OK) {

//                str_image = String.valueOf(uri_cameraimage);
                str_image = uri_cameraimage.getPath();
                Log.e("uri++00", String.valueOf(str_image));

                Glide.with(this)
                        .load(uri_cameraimage)
                        .error(R.drawable.profile_pic)
                        .into(img_user);


            }


        } catch (Exception e) {

            Log.e("exception", e.toString());
            Snackbar.make(btn_save, e.toString(), Snackbar.LENGTH_LONG).show();
        }

    }

}


