/*
 * Katie Ray
 * Project: ulex
 * March 15, 2003
 * tree.h: header file for the tree structure
 */

struct tree {
  int label;
  char* text;
  struct tree* children[3];
};

#include "tree.c"

