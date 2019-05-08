# SingularInterface: A GAP interface to Singular
#
# Copyright of SingularInterface belongs to its developers.
# Please refer to the COPYRIGHT file for details.
#
# SPDX-License-Identifier: GPL-2.0-or-later

DeclareOperation("SI_ring",[IsSI_ring, IsSI_Object]);
DeclareOperation("SI_ring",[IsInt,IsList]);
DeclareOperation("SI_ring",[IsInt,IsList,IsList]);
# to get back associated ring
DeclareOperation("SI_ring",[IsSI_Object]);

