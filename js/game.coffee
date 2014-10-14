---
---

$ ->
    basil = new window.Basil()

    card_settings = basil.get("card_settings")
    if not card_settings?
        card_settings = {
            n_hn_foc: 6
            n_wws: 5
            blacklist: [
                "Helena Zontero"
                "Miniera Abbandonata"
                "Bavaglio"
                "Lady Rosa del Texas"
            ]
        }
        basil.set("card_settings", card_settings)

    $('input#n_hn_foc').val card_settings.n_hn_foc
    $('input#n_wws').val card_settings.n_wws
    window.settings_cards(card_settings)
