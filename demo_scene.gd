extends Control

export (NodePath) var test_mode_node_path
export (NodePath) var consent_node_path
export (NodePath) var autocache_node_path
export (NodePath) var diable_network_node_path
export (NodePath) var log_level_node_path
export (NodePath) var init_btn_node_path
export (NodePath) var init_state_node_path

const _ANDROID_APP_KEY: String = "fee50c333ff3825fd6ad6d38cff78154de3025546d47a84f"
const _IOS_APP_KEY: String = "466de0d625e01e8811c588588a42a55970bc7c132649eede"

onready var test_mode_check_button = get_node(test_mode_node_path)
onready var consent_check_button = get_node(consent_node_path)
onready var autocache_check_button = get_node(autocache_node_path)
onready var disable_network_check_button = get_node(diable_network_node_path)
onready var log_level_dropdown = get_node(log_level_node_path)
onready var init_button = get_node(init_btn_node_path)
onready var init_state = get_node(init_state_node_path)

func _ready():
	_set_dropdown_values()

func _change_init_state_color(newColor:Color):
	init_state.color = newColor

func _set_dropdown_values():
	log_level_dropdown.add_item("Verbose")
	log_level_dropdown.add_item("Debug")
	log_level_dropdown.add_item("None")

func _on_InitButton_pressed():
	test_mode_check_button.disabled = true
	consent_check_button.disabled = true
	autocache_check_button.disabled = true
	disable_network_check_button.disabled = true
	log_level_dropdown.set_disabled(true)
	init_button.set_disabled(true)
	_change_init_state_color(Color.yellow)
	Appodeal.set_log_level(log_level_dropdown.selected) # Appodeal.LogLevel.VERBOSE
	if consent_check_button.is_pressed():
		Appodeal.update_ccpa_user_consent(Appodeal.CcpaConsent.OPT_IN)
		Appodeal.update_gdpr_user_consent(Appodeal.GdprConsent.PERSONALIZED)
	if disable_network_check_button.is_pressed():
		Appodeal.disable_network(AppodealNetwork.VUNGLE)
		Appodeal.disable_network_for_ad_types(AppodealNetwork.YANDEX, Appodeal.AdType.MREC)
	Appodeal.set_testing(test_mode_check_button.is_pressed()) # true / false
	Appodeal.set_auto_cache(Appodeal.AdType.INTERSTITIAL, autocache_check_button.is_pressed()) # true / false
	Appodeal.set_auto_cache(Appodeal.AdType.REWARDED_VIDEO, autocache_check_button.is_pressed()) # true / false
	Appodeal.set_smart_banners(true)
	Appodeal.set_728x90_banners(false)
	Appodeal.set_banner_animation(true)
	Appodeal.set_banner_roatation(-110, 90)
	Appodeal.set_use_safe_area(true)
	Appodeal.set_user_id("007")
	Appodeal.mute_videos_if_calls_muted(true)
	Appodeal.set_child_directed_treatment(false)
	Appodeal.set_custom_filter_bool("be", true)
	Appodeal.set_custom_filter_int("answer", 42)
	Appodeal.set_custom_filter_float("temp", -35.5)
	Appodeal.set_custom_filter_string("cake", "lie")
	Appodeal.reset_custom_filter("cake")
	Appodeal.set_extra_data_bool("result", false)
	Appodeal.set_extra_data_int("year", 2022)
	Appodeal.set_extra_data_float("solo", 3.22)
	Appodeal.set_extra_data_string("everybody", "lies")
	Appodeal.reset_extra_data("year")
	var ad_types = Appodeal.AdType.BANNER | Appodeal.AdType.INTERSTITIAL | Appodeal.AdType.MREC | Appodeal.AdType.REWARDED_VIDEO
	if (OS.get_name() == "Android"):
		Appodeal.initialize(_ANDROID_APP_KEY, ad_types)
	if (OS.get_name() == "iOS"):
		Appodeal.initialize(_IOS_APP_KEY, ad_types);

func _on_IsInitializedButton_pressed():
	print("[APD-GD] IsInitializied?: %s" % Appodeal.is_initialized(Appodeal.AdType.INTERSTITIAL))

func _on_InterCacheButton_pressed():
	if !Appodeal.is_auto_cache_enabled(Appodeal.AdType.INTERSTITIAL):
		Appodeal.cache(Appodeal.AdType.INTERSTITIAL)
	else:
		printerr("[APD-GD] Autocache is enabled.")

func _on_InterCanShowButton_pressed():
	var canShow = Appodeal.is_loaded(Appodeal.AdType.INTERSTITIAL) and Appodeal.can_show_for_default_placement(Appodeal.AdType.INTERSTITIAL)
	print("[APD-GD] CanShow?: %s" % canShow)

func _on_InterShowButton_pressed():
	if Appodeal.can_show_for_default_placement(Appodeal.AdType.INTERSTITIAL):
		Appodeal.show(Appodeal.ShowStyle.INTERSTITIAL)
	else:
		printerr("[APD-GD] No interstitial ad is available")

func _on_RVCacheButton_pressed():
	if !Appodeal.is_auto_cache_enabled(Appodeal.AdType.REWARDED_VIDEO):
		Appodeal.cache(Appodeal.AdType.REWARDED_VIDEO)
	else:
		printerr("[APD-GD] Autocache is enabled.")

func _on_RVCanShowButton_pressed():
	var canShow = Appodeal.is_loaded(Appodeal.AdType.REWARDED_VIDEO) and Appodeal.can_show_for_placement(Appodeal.AdType.REWARDED_VIDEO, "get_free_hint")
	print("[APD-GD] CanShow?: %s" % canShow)

func _on_RVShowButton_pressed():
	if Appodeal.can_show_for_placement(Appodeal.AdType.REWARDED_VIDEO, "get_free_hint"):
		print ("[APD-GD] RV Predicted eCPM: %s" % Appodeal.get_predicted_ecpm(Appodeal.AdType.REWARDED_VIDEO))
		Appodeal.show_for_placement(Appodeal.ShowStyle.REWARDED_VIDEO, "get_free_hint")
	else:
		printerr("[APD-GD] No RV ad is available")

func _on_BannerShowLeftButton_pressed():
	Appodeal.show(Appodeal.ShowStyle.BANNER_LEFT)

func _on_BannerShowTopButton_pressed():
	Appodeal.show(Appodeal.ShowStyle.BANNER_TOP)

func _on_BannerShowRightButton_pressed():
	Appodeal.show(Appodeal.ShowStyle.BANNER_RIGHT)

func _on_BannerShowBottomButton_pressed():
	Appodeal.show(Appodeal.ShowStyle.BANNER_BOTTOM)

func _on_BannerHideButton_pressed():
	Appodeal.hide_banner()

func _on_BannerDestroyButton_pressed():
	Appodeal.destroy(Appodeal.AdType.BANNER)

func _on_BannerShowCustomButton_pressed():
	Appodeal.show_banner_view(AppodealViewPosition.HORIZONTAL_CENTER, AppodealViewPosition.VERTICAL_BOTTOM, "default")

func _on_BannerHideCustomButton_pressed():
	Appodeal.hide_banner_view()

func _on_MrecShowButton_pressed():
	Appodeal.show_mrec_view(AppodealViewPosition.HORIZONTAL_CENTER, 100, "default")

func _on_MrecHideButton_pressed():
	Appodeal.hide_mrec_view()

func _on_MrecDestroyButton_pressed():
	Appodeal.destroy(Appodeal.AdType.MREC)

func _on_LogEventButton_pressed():
	Appodeal.log_event("level_passed", {"level":"1", "stars":3})

func _on_ValidateInAppButton_pressed():
	if (OS.get_name() == "Android"):
		var additionalParams = {
			"user_id":"007",
			"sessions_count":"1"
		}
		var payload = {
			"purchase_type":Appodeal.PlayStorePurchaseType.InApp,
			"public_key":"111",
			"signature":"222",
			"purchase_data":"333",
			"purchase_token":"666",
			"purchase_timestamp":0,
			"developer_payload":"777",
			"order_id":"555",
			"sku":"444",
			"price":"1.99",
			"currency":"USD",
			"additional_parameters":additionalParams
		}
		Appodeal.validate_play_store_inapp_purchase(payload)
	if (OS.get_name() == "iOS"):
		var additionalParams = {
			"user_id":"007",
			"sessions_count":1
		}
		var payload = {
			"purchase_type":Appodeal.AppStorePurchaseType.Consumable,
			"product_id":"500_gold_coins",
			"transaction_id":"42",
			"price":"2",
			"currency":"USD",
			"additional_parameters":additionalParams
		}
		Appodeal.validate_app_store_inapp_purchase(payload)

func _on_TestActivityButton_pressed():
	Appodeal.start_test_activity()

func _on_AppodealSignals_initialization_finished(errors):
	print("[APD-GD] initialization_finished signal emitted. Errors: %s" % errors)
	_change_init_state_color(Color.green)
	Appodeal.track_inapp_purchase(100, "USD")
	print("[APD-GD] banner get_networks: %s" % Appodeal.get_networks(Appodeal.AdType.BANNER))
	print("[APD-GD] is_smart_banners_enabled: %s" % Appodeal.is_smart_banners_enabled())
	print("[APD-GD] get_user_id: %s" % Appodeal.get_user_id())
	print("[APD-GD] get_version: %s" % Appodeal.get_version())
	print("[APD-GD] get_plugin_version: %s" % Appodeal.get_plugin_version())
	print("[APD-GD] get_segment_id: %s" % Appodeal.get_segment_id())
	print("[APD-GD] get_reward_amount: %s" % Appodeal.get_reward_amount("default"))
	print("[APD-GD] get_reward_currency: %s" % Appodeal.get_reward_currency("default"))	

func _on_AppodealSignals_ad_revenue_received(params):
	print("[APD-GD] ad_revenue_received signal emitted")
	for key in params:
		print("[APD-GD] '%s':'%s'" % [key, params[key]])

func _on_AppodealSignals_interstitial_loaded(is_precache):
	print("[APD-GD] interstitial_loaded signal emitted. IsPrecache?: %s" % is_precache)
	print("[APD-GD] is_precache: %s" % Appodeal.is_precache(Appodeal.AdType.INTERSTITIAL))

func _on_AppodealSignals_interstitial_shown():
	print("[APD-GD] interstitial_shown signal emitted")

func _on_AppodealSignals_interstitial_show_failed():
	print("[APD-GD] interstitial_show_failed signal emitted")

func _on_AppodealSignals_interstitial_failed_to_load():
	print("[APD-GD] interstitial_failed_to_load signal emitted")

func _on_AppodealSignals_interstitial_closed():
	print("[APD-GD] interstitial_closed signal emitted")

func _on_AppodealSignals_interstitial_clicked():
	print("[APD-GD] interstitial_clicked signal emitted")

func _on_AppodealSignals_interstitial_expired():
	print("[APD-GD] interstitial_expired signal emitted")

func _on_AppodealSignals_banner_clicked():
	print("[APD-GD] banner_clicked signal emitted")

func _on_AppodealSignals_banner_expired():
	print("[APD-GD] banner_expired signal emitted")

func _on_AppodealSignals_banner_failed_to_load():
	print("[APD-GD] banner_failed_to_load signal emitted")

func _on_AppodealSignals_banner_loaded(height, is_precache):
	print("[APD-GD] banner_loaded signal emitted. Height: %s, IsPrecache?: %s" % [height, is_precache])

func _on_AppodealSignals_banner_show_failed():
	print("[APD-GD] banner_show_failed signal emitted")

func _on_AppodealSignals_banner_shown():
	print("[APD-GD] banner_shown signal emitted")

func _on_AppodealSignals_mrec_clicked():
	print("[APD-GD] mrec_clicked signal emitted")

func _on_AppodealSignals_mrec_expired():
	print("[APD-GD] mrec_expired signal emitted")

func _on_AppodealSignals_mrec_failed_to_load():
	print("[APD-GD] mrec_failed_to_load signal emitted")

func _on_AppodealSignals_mrec_loaded(is_precache):
	print("[APD-GD] mrec_loaded signal emitted")

func _on_AppodealSignals_mrec_show_failed():
	print("[APD-GD] mrec_show_failed signal emitted")

func _on_AppodealSignals_mrec_shown():
	print("[APD-GD] mrec_shown signal emitted")

func _on_AppodealSignals_rewarded_video_clicked():
	print("[APD-GD] rewarded_video_clicked signal emitted")

func _on_AppodealSignals_rewarded_video_closed(finished):
	print("[APD-GD] rewarded_video_closed signal emitted. IsFinished?: %s" % finished)

func _on_AppodealSignals_rewarded_video_expired():
	print("[APD-GD] rewarded_video_expired signal emitted")

func _on_AppodealSignals_rewarded_video_failed_to_load():
	print("[APD-GD] rewarded_video_failed_to_load signal emitted")

func _on_AppodealSignals_rewarded_video_finished(amount, name):
	print("[APD-GD] rewarded_video_finished signal emitted. Amount: %s, Name: %s" % [amount, name])

func _on_AppodealSignals_rewarded_video_loaded(is_precache):
	print("[APD-GD] rewarded_video_loaded signal emitted. IsPrecache?: %s" % is_precache)

func _on_AppodealSignals_rewarded_video_show_failed():
	print("[APD-GD] rewarded_video_show_failed signal emitted")

func _on_AppodealSignals_rewarded_video_shown():
	print("[APD-GD] rewarded_video_shown signal emitted")

func _on_AppodealSignals_inapp_purchase_validation_failed(reason):
	print("[APD-GD] inapp_purchase_validation_failed signal emitted. reason: %s" % reason)

func _on_AppodealSignals_inapp_purchase_validation_succeded(json):
	print("[APD-GD] inapp_purchase_validation_succeded signal emitted. json: %s" % json)
