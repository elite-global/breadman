package com.app.breadman;

import android.content.Context;
import android.graphics.Typeface;
import android.net.Uri;
import android.support.v4.app.Fragment;
import android.support.v7.widget.RecyclerView;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.style.StyleSpan;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.util.ArrayList;


class NotificationAdapter extends RecyclerView.Adapter<NotificationAdapter.ViewHolder>{

    private Context context;
    private ArrayList<NotificationModel> Notification;
    private LayoutInflater mInflater;
    private Fragment fragment;


    public NotificationAdapter(Context cntx, ArrayList<NotificationModel> Notification, Fragment fragment) {
        this.mInflater = LayoutInflater.from(cntx);
        this.Notification = Notification;
        context = cntx;
        this.fragment = fragment;

    }

    // inflates the row layout from xml when needed
    @Override
    public NotificationAdapter.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = mInflater.inflate(R.layout.item_notification, parent, false);
        NotificationAdapter.ViewHolder viewHolder = new NotificationAdapter.ViewHolder(view);
        return viewHolder;
    }

    @Override
    public void onBindViewHolder(final ViewHolder holder, final int position) {

        Log.e("1111111111111", String.valueOf(Notification));

        String name = Notification.get(position).getUserName();

        SpannableString str = new SpannableString(name + " sent you an add request.");
        str.setSpan(new StyleSpan(Typeface.BOLD), 0, name.length(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        holder.tv_userName.setText(str);

        holder.li.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                ((NotificationFragment)fragment).AddRequestDialog();


            }
        });



    }

    // total number of rows
    @Override
    public int getItemCount() {

        Log.e("00000", String.valueOf(Notification));
        return Notification.size();

    }

    // stores and recycles views as they are scrolled off screen
    public class ViewHolder extends RecyclerView.ViewHolder {

        public LinearLayout li;
        public ImageView image;
        public TextView tv_userName;


        public ViewHolder(View itemView) {
            super(itemView);

            li = itemView.findViewById(R.id.li);
            image = itemView.findViewById(R.id.image);
            tv_userName = itemView.findViewById(R.id.tv_userName);

        }

    }

}
