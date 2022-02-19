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

public class Vee.DMG.Processor.Operation : GLib.Object {

    public string description { get; construct; }
    // The length of the operation (in bytes)
    //  public int length { get; construct; }
    //
    //  public int ticks { get; construct; }

    protected unowned Lambda exec;

    public Operation (string description, Lambda exec /*, int length, int ticks*/) {
        Object (
            description: description
            //  ticks: ticks,
            //  length: length
        );
        this.exec = exec;
    }

    public int execute (Vee.DMG.Processor.CPU cpu) {
        int result = exec (cpu);
        //  handle_flags (cpu);
        //  cpu.set_pc (cpu.get_pc () + length);
        return result;
    }

    //  protected void handle_flags (Vee.DMG.Processor.CPU cpu) {
    //      // TODO: Implement
    //  }

    public delegate int Lambda (Vee.DMG.Processor.CPU cpu);

}
