A Simple Example — Using the CGI Icon Library
=============================================

This page is a sample HTML form used with the CGI Icon library examples
(``simple.icn`` / ``simple2.icn`` / ``appform.icn`` in this directory).

Example form
------------

The original demo posted form fields to ``/cgi-bin/simple.cgi``. Field
names match the sample Icon CGI handlers.

1. **Name** — text field ``name``
2. **Age** — text field ``age``
3. **Favorite Food** — checkboxes ``pizza``, ``burger``, ``taco``
4. **Favorite Color** — checkboxes ``red``, ``green``, ``blue``
5. **Education** — checkboxes ``bs``, ``ms``, ``phd``
6. **Comments** — textarea ``comments``

Sample markup
-------------

.. code-block:: html

   <form method="GET" action="/cgi-bin/simple.cgi">
     <p>1. Enter your name
        <input type="text" name="name" size="25"></p>
     <p>2. Enter your Age:
        <input type="text" name="age" size="2"> Years Old</p>
     <p>3. Favorite Food
        <input type="checkbox" name="pizza">Pizza
        <input type="checkbox" name="burger">Hamburger
        <input type="checkbox" name="taco">Tacos</p>
     <p>4. Favorite Color:
        <input type="checkbox" name="red">Red
        <input type="checkbox" name="green">Green
        <input type="checkbox" name="blue">Blue</p>
     <p>5. Education:
        <input type="checkbox" name="bs">BS
        <input type="checkbox" name="ms">MS
        <input type="checkbox" name="phd">PHD</p>
     <p>Comments:<br>
        <textarea rows="5" cols="60" name="comments"></textarea></p>
     <input type="submit" value="Submit Data">
     <input type="reset" value="Reset Form">
   </form>
