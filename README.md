# OYes2017
Instasolve project

swift-demo is currently the main project

Existing bugs:
1. Search for "TODO:" in the project
2. Timing method should be more elegant (not locally)
3. Picture view is so so ugly when displayed in category view controller and request view controller (Fixed !!!!!!!!!!!!!!)
4. Payment: remember user card info and update card info
5. Press Camera shows a white stripe(白带)
6. Dismiss library is laggard
7. In summery page, press category can go back to category page.
8. Press any image can go back to edit page
9. In tutor app, if user press empty(not loaded yet) image, crush
10. when two tutor app login with same ID, it crush when pressing rescue (need to check current user for "nil", logout if nil)
11. when student press home button during a request, need to cancel request (look in AppDelegate.swift)
12. When student close the app, the pending problem should be removed
13. Once a student ends the sesssion the tutor needs to be notified. Add an observer to accompish this.
14. Sometimes a tutor can enter a session while the student does not (i.e. student cancels and tutors sends request at the same time). So we need to add an observer once the tutor is in the chat to see if the student is still there.
15. When a new question is answered by a tutor the session needs to be clear, that is no old messages are appearing.
16. Create session based chat history
