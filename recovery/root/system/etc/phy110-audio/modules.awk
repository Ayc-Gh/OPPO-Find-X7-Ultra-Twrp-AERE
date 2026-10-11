# Derive dependency order from the mounted current-slot modules.dep.
function leaf(p) { sub(/^.*\//,"",p); return p }
function visit(n, a,c,i) {
 if (done[n]) return
 if (active[n]) { print "Module dependency cycle" > "/dev/stderr"; exit 1 }
 if (!(n in deps)) { print "Missing dependency: " n > "/dev/stderr"; exit 1 }
 active[n]=1
 c=split(deps[n],a," ")
 for(i=1;i<=c;i++) if(a[i]!="") visit(leaf(a[i]))
 active[n]=0; done[n]=1; print n
}
{ split($0,parts,":"); deps[leaf(parts[1])]=parts[2] }
END {
 split("stub_dlkm.ko swr_haptics_dlkm.ko msm_ext_display.ko hdmi_dlkm.ko btpower.ko bt_fm_slim.ko pinctrl_lpi_dlkm.ko q6_dlkm.ko gpr_dlkm.ko snd_event_dlkm.ko spf_core_dlkm.ko lpass_cdc_tx_macro_dlkm.ko lpass_cdc_va_macro_dlkm.ko lpass_cdc_wsa_macro_dlkm.ko lpass_cdc_wsa2_macro_dlkm.ko wcd939x_slave_dlkm.ko wcd9378_slave_dlkm.ko wcd937x_slave_dlkm.ko swr_dmic_dlkm.ko oplus_audio_sipa.ko oplus_audio_aw882xx.ko oplus_audio_tfa98xx_v6.ko machine_dlkm.ko",targets," ")
 for(j=1;j<=23;j++) if(targets[j] in deps) visit(targets[j])
 if(!done["oplus_audio_tfa98xx_v6.ko"] || !done["machine_dlkm.ko"]) exit 1
}
