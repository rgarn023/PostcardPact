# Offline Prototype Manual Test Checklist

1. Open project in Godot 4.7.1 and run (`F5`).
2. Home shows title **Postcard Pact** and independent-app disclaimer.
3. With no profile, Home shows setup CTA → opens Profile.
4. Profile validation:
   - blank display name rejected
   - blank trainer code rejected
   - letters in trainer code rejected
   - region required
5. Save valid profile; return to Home; summary shows name, region, needed-region count.
6. Close app fully; reopen; Home still shows saved profile (`user://profile.json`).
7. Find shows sample cards labeled **Prototype Match**.
8. Journey checkboxes persist after reopen.
9. Trades save wanted/offered text locally; disclaimer visible.
10. Profile → Reset Profile clears local profile; Home returns to empty state.
11. Bottom nav always shows only one page; active tab button is disabled.
