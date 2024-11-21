# Generated by Django 5.1.2 on 2024-11-21 06:51

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("core", "0005_alter_chosenactivity_activity_and_more"),
    ]

    operations = [
        migrations.AddField(
            model_name="chosenactivity",
            name="description",
            field=models.TextField(null=True),
        ),
        migrations.AddField(
            model_name="chosenactivity",
            name="endTimeZone",
            field=models.CharField(max_length=255, null=True),
        ),
        migrations.AddField(
            model_name="chosenactivity",
            name="isAllDay",
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name="chosenactivity",
            name="location",
            field=models.CharField(max_length=255, null=True),
        ),
        migrations.AddField(
            model_name="chosenactivity",
            name="startTimeZone",
            field=models.CharField(max_length=255, null=True),
        ),
        migrations.AddField(
            model_name="chosenactivity",
            name="title",
            field=models.CharField(max_length=255, null=True),
        ),
    ]