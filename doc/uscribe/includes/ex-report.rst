:title: Report Mode Example
:author: Uscribe Maintainers
:trnumber: 0
:date: 2026-08-07
:abstract: Minimal fixture for UTR-style report metadata, external
   links, sub/sup, and raw passthrough.
:docclass: report

Introduction
============

See the Unicon site at `unicon.org <http://unicon.org>`_.
Water is H:sub:`2`O; e:sup:`x` grows fast.
Cited works include :cite:`unicon-site` and :cite:`Griswold:1997:IPL`.
A footnote looks like this:footnote:`Sample footnote body.`.
Inline math :math:`E=mc^2` and a display block:

.. math::

   a^2 + b^2 = c^2

.. raw:: html

   <!-- raw html ok -->

.. raw:: latex

   % raw latex ok

References
==========

.. bibliography:: ex-report.bib
