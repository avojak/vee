/*
 * Copyright (c) 2021 Andrew Vojak (https://avojak.com)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA
 *
 * Authored by: Andrew Vojak <andrew.vojak@gmail.com>
 */

public class Vee.CHIP8.Audio.APU : GLib.Object {

    public GLib.File file { get; construct; }

    private Canberra.Context context;
    private bool is_cached = false;

    public APU () {
        Object (
            file: GLib.File.new_for_path (Constants.PKG_DATA_DIR + "/" + "beep.wav")
        );
    }

    construct {
        if (!file.query_exists ()) {
            warning ("Audio file not found: %s", file.get_path ());
        }
        Canberra.Context ctx;
        if (Canberra.Context.create (out ctx) != Canberra.SUCCESS) {
            warning ("Failed to initialize canberra context");
        }
        if (ctx.change_props (
                Canberra.PROP_APPLICATION_ID, Constants.APP_ID,
                Canberra.PROP_APPLICATION_NAME, Constants.APP_NAME,
                null
            ) != Canberra.SUCCESS) {
            warning ("Failed to set canberra context properties");
        }
        if (ctx.open () != Canberra.SUCCESS) {
            warning ("Failed to open canberra context");
        }
        this.context = (owned) ctx;
        //  cache_file ();
    }

    private static double amplitude_to_decibels (double amplitude) {
        return 20.0 * Math.log10 (amplitude);
    }

    public void play () {
        Canberra.Proplist properties;
        if (Canberra.Proplist.create (out properties) != Canberra.SUCCESS) {
            warning ("Failed to create canberra properties");
        }
        //  properties.sets (Canberra.PROP_MEDIA_ROLE, "game");
        //  properties.sets (Canberra.PROP_MEDIA_FILENAME, file.get_path ());
        //  properties.sets (Canberra.PROP_CANBERRA_VOLUME, ((float) amplitude_to_decibels (1.0)).to_string ());
        //  properties.sets (Canberra.PROP_EVENT_ID, "beep");
        properties.sets (Canberra.PROP_MEDIA_NAME, "beep");
        properties.sets (Canberra.PROP_MEDIA_FILENAME, file.get_path ());
        properties.sets (Canberra.PROP_CANBERRA_VOLUME, ((float) amplitude_to_decibels (1.0)).to_string ());
        //  properties.sets (Canberra.PROP_EVENT_ID, "camera-shutter");
        //  properties.sets (Canberra.PROP_EVENT_DESCRIPTION, "Photo taken");
        var status = context.play_full (0, properties);
        if (status != Canberra.SUCCESS) {
            warning ("Failed to play sound: %s", Canberra.strerror (status));
        }
    }

    //  private void cache_file () {
    //      Canberra.Proplist properties;
    //      Canberra.Proplist.create (out properties);
    //      properties.sets (Canberra.PROP_MEDIA_NAME, "beep");
    //      properties.sets (Canberra.PROP_MEDIA_FILENAME, file.get_path ());
    //      var status = context.cache_full (properties);
    //      if (status != Canberra.SUCCESS) {
    //          warning ("Failed to cache sound: %s", Canberra.strerror (status));
    //      } else {
    //          is_cached = true;
    //      }
    //  }

    public void stop () {

    }

}