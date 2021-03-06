/obj/machinery/computer/munitions_console
	name = "munitions control computer"

	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "atmos_key"
	icon_screen = "munitions"

	var/list/ammo_racks = list()
	var/list/cannons = list()

/obj/machinery/computer/munitions_console/New()
	..()
	link_ammo_racks()

/obj/machinery/computer/munitions_console/proc/link_ammo_racks()
	sleep(1) //give time for the other things to load

	for(var/obj/machinery/ammo_rack/M in machines)
		ammo_racks += M
	for(var/obj/machinery/mac_breech/B in machines)
		cannons += B

/obj/machinery/computer/munitions_console/attack_hand(mob/user)
	var/dat = "<B>Munitions Control Computer</B><HR>"
	dat += "<BR>"
	dat += "<B>Connected MAC Cannons:</B>"
	dat += "<HR>"

	for(var/obj/machinery/mac_breech/B in cannons)
		dat += "<BR><B><U>MAC Cannon ([B.loc.loc]):</U></B>"
		if(B.stat & NOPOWER)
			dat += "<BR>State: <font color=red>Offline</font>"
		else
			dat += "<BR>State: [B.charge_process >= 100 ? "<font color=green>Charged</font>" : "<font color=yellow>Charging</font>"]"
			dat += "<BR>Loaded: [B.loaded_shell ? "[B.loaded_shell.name]" : "None"]"

	dat += "<BR><BR><B>Connected Ammunition Racks:</B>"
	dat += "<HR>"

	for(var/obj/machinery/ammo_rack/M in ammo_racks)
		dat += "<BR><B>[M.name]</B> - (<A href=?src=\ref[src];dispense=\ref[M]>Dispense</A>)"
		for(var/obj/structure/shell/S in M.loaded_shells)
			dat += "<BR>-[S.name]"

	var/datum/browser/popup = new(user, "scanner", name, 800, 660)

	popup.set_content(dat)
	popup.open(0)

/obj/machinery/computer/munitions_console/Topic(href,href_list)
	..()
	if(href_list["dispense"])
		var/obj/machinery/ammo_rack/M = locate(href_list["dispense"])
		M.dispense_ammo()
	attack_hand(usr)
