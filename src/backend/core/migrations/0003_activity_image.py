# Generated by Django 5.1.2 on 2024-12-09 06:07

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("core", "0002_alter_activity_category"),
    ]

    operations = [
        migrations.AddField(
            model_name="activity",
            name="image",
            field=models.URLField(default="wef"),
            preserve_default=False,
        ),
    ]
