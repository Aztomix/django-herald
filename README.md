# django-herald

[![Latest PyPI version](https://badge.fury.io/py/django-herald.svg)](https://pypi.python.org/pypi/django-herald)
[![Build Status](https://travis-ci.org/worthwhile/django-herald.svg?branch=master)](https://travis-ci.org/worthwhile/django-herald)
[![Coverage Status](https://coveralls.io/repos/github/worthwhile/django-herald/badge.svg?branch=master)](https://coveralls.io/github/worthwhile/django-herald?branch=master)

[![Logo](https://github.com/worthwhile/django-herald/blob/master/logo.png)](https://github.com/worthwhile/django-herald)

Django library for separating the message content from transmission method

# Installation

1. `pip install django-herald`
2. Add `herald` and `django.contrib.sites` to `INSTALLED_APPS`.
3. Add herald's URLS:

        if settings.DEBUG:
            urlpatterns = [
                url(r'^herald/', include('herald.urls')),
            ] + urlpatterns

# Usage

1. Create a `notifications.py` file in any django app. This is where your notification classes will live. Add a class like this:

        from herald import registry
        from herald.base import EmailNotification


        class WelcomeEmail(EmailNotification):  # extend from EmailNotification for emails
           template_name = 'welcome_email'  # name of template, without extension
           subject = 'Welcome'  # subject of email

           def __init__(self, user):  # optionally customize the initialization
               self.context = {'user': user}  # set context for the template rendering
               self.to_emails = [user.email]  # set list of emails to send to

           @staticmethod
           def get_demo_args():  # define a static method to return list of args needed to initialize class for testing
               from users.models import User
               return [User.objects.order_by('?')[0]]

        registry.register(WelcomeEmail)  # finally, register your notification class

2. Create templates for rendering the email using this file structure:

        templates/
            herald/
                text/
                    welcome_email.txt
                html/
                    welcome_email.html

3. Test how your email looks by navigating to `/herald/`.

4. Send your email wherever you need in your code:

        WelcomeEmail(user).send()

5. View the sent emails in django admin and even be able to resend it.

## Asynchronous Email Sending

If you are sending slightly different emails to a large number of people, it might take quite a while to process. By default, Django will process this all synchronously. For asynchronous support, we recommend django-celery-email. It is very straightfoward to setup and integrate: https://github.com/pmclanahan/django-celery-email


## User Disabled Notifications

If you want to disable certain notifications per user, add a record to the UserNotification table and
add notifications to the disabled_notifications many to many table.

For example:

        user = User.objects.get(id=user.id)

        notification = Notification.objects.get(notification_class='MyNotification')

        # disable the notification
        user.usernotification.disabled_notifications.add(notification)


# Running Tests

	python runtests.py
