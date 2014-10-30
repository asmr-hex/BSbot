type phrase = Str of string | Opts of phrase array array

let _ = Random.self_init ()

let randelt a = a.(Random.int (Array.length a))
let rec print phr = match phr with
  Str  s       -> print_string s
| Opts options ->
    let parts = randelt options in
    Array.iter print parts

(* Grammar definitions *)
let rec top = Opts [|
  [| paper;|];
|]

and zdigit = Opts [|
  [| Str "0";|];
  [| Str "1";|];
  [| Str "2";|];
  [| Str "3";|];
  [| Str "4";|];
  [| Str "5";|];
  [| Str "6";|];
  [| Str "7";|];
  [| Str "8";|];
  [| Str "9";|];
|]

and nzdigit = Opts [|
  [| Str "1";|];
  [| Str "2";|];
  [| Str "3";|];
  [| Str "4";|];
  [| Str "5";|];
  [| Str "6";|];
  [| Str "7";|];
  [| Str "8";|];
  [| Str "9";|];
|]

and smallinteger = Opts [|
  [| nzdigit;|];
  [| nzdigit; zdigit;|];
  [| nzdigit; zdigit;|];
|]

and n = Opts [|
  [| Str "n";|];
  [| Str "m";|];
  [| nzdigit;|];
|]

and ring = Opts [|
  [| Str "\\Z";|];
  [| Str "\\Q";|];
  [| Str "\\R";|];
  [| Str "\\C";|];
  [| Str "\\mathbb{H}";|];
|]

and group = Opts [|
  [| liegroup;|];
  [| discretegroup;|];
|]

and liegroup = Opts [|
  [| Str "SU("; n; Str ")";|];
  [| Str "Sp("; n; Str ")";|];
  [| Str "SO("; n; Str ")";|];
  [| Str "G_2";|];
  [| Str "F_4";|];
  [| Str "E_6";|];
  [| Str "E_7";|];
  [| Str "E_8";|];
  [| Str "Spin("; n; Str ")";|];
|]

and discretegroup = Opts [|
  [| Str "\\Z";|];
  [| Str "\\Z_"; n;|];
  [| Str "\\Z^"; n;|];
  [| Str "Hom("; ring; Str ","; ring; Str ")";|];
  [| Str "H^"; n; Str "("; mathspace; Str ","; ring; Str ")";|];
  [| Str "H_"; n; Str "("; mathspace; Str ","; ring; Str ")";|];
  [| Str "Ext^"; n; Str "("; ring; Str ","; ring; Str ")";|];
  [| Str "M_"; n; Str "("; ring; Str ")";|];
  [| Str "SL_"; n; Str "("; ring; Str ")";|];
  [| Str "Dih_"; n;|];
|]

and groupaction = Opts [|
  [| Str "orbifold";|];
  [| Str "quotient";|];
|]

and space = Opts [|
  [| pluralspace;|];
  [| singspace;|];
  [| mathspace;|];
|]

and singspace = Opts [|
  [| Str "a "; spacetype;|];
  [| Str "a "; spaceadj; Str " "; spacetype;|];
  [| properspacename;|];
  [| spaceadj; Str " "; properspacename;|];
  [| mathspace;|];
  [| mathspace;|];
  [| Str "a "; bundletype; Str " bundle over "; space;|];
  [| singspace; Str " fibered over "; singspace;|];
  [| Str "the moduli space of "; pluralspace;|];
  [| Str "a "; spacetype; Str " "; spaceproperty;|];
  [| Str "the "; spacepart; Str " of "; space;|];
  [| Str "a "; group; Str " "; groupaction; Str " of "; singspace;|];
  [| Str "the near horizon geometry of "; singspace;|];
|]

and pluralspace = Opts [|
  [| spacetype; Str "s";|];
  [| spaceadj; Str " "; spacetype; Str "s";|];
  [| n; Str " copies of "; mathspace;|];
  [| pluralspace; Str " fibered over "; space;|];
  [| spacetype; Str "s "; spaceproperty;|];
  [| bundletype; Str " bundles over "; space;|];
  [| Str "moduli spaces of "; pluralspace;|];
  [| group; Str " "; groupaction; Str "s of "; pluralspace;|];
|]

and spaceadj = Opts [|
  [| spaceadj; Str " "; spaceadj;|];
  [| Str "warped";|];
  [| Str "squashed";|];
  [| Str "non-compact";|];
  [| Str "compact";|];
  [| Str "hyper-Kahler";|];
  [| Str "Kahler";|];
  [| Str "exotic";|];
  [| Str "projective";|];
  [| Str "noncommutative";|];
  [| Str "fuzzy";|];
  [| Str "elliptically-fibered";|];
  [| Str "spin";|];
  [| Str "hyperbolic";|];
  [| Str "Einstein";|];
  [| Str "Ricci-flat";|];
  [| Str "Euclidean";|];
  [| Str "Minkowskian";|];
  [| Str "planar";|];
  [| Str "harmonic";|];
  [| Str "symplectic";|];
  [| Str "ALE";|];
  [| Str "ALF";|];
|]

and spaceproperty = Opts [|
  [| Str "of "; group; Str " holonomy";|];
  [| Str "with "; mathadj; Str " "; mathobj;|];
|]

and bundletype = Opts [|
  [| group;|];
  [| Str "line";|];
  [| Str "affine";|];
  [| mathspace;|];
|]

and spacetype = Opts [|
  [| Str "Calabi-Yau "; n; Str "-fold";|];
  [| Str "Riemann surface";|];
  [| Str "manifold";|];
  [| n; Str "-fold";|];
  [| n; Str "-manifold";|];
  [| Str "symmetric space";|];
  [| Str "K3";|];
  [| Str "del-Pezzo";|];
  [| Str "Klebanov-Strassler background";|];
  [| Str "RS1 background";|];
  [| Str "lens space";|];
  [| Str "Hirzebruch surface";|];
  [| Str "Enriques surface";|];
  [| Str "rational surface";|];
  [| Str "ALE fibration";|];
  [| Str "ALF space";|];
  [| Str "linear dilaton background";|];
  [| Str "Atiyah-Hitchen manifold";|];
|]

and generalspacetype = Opts [|
  [| Str "surface";|];
  [| Str "line";|];
  [| Str "hyperplane";|];
  [| Str "hypersurface";|];
|]

and properspacename = Opts [|
  [| Str "Anti de Sitter Space";|];
  [| Str "de Sitter Space";|];
  [| Str "Taub-NUT Space";|];
  [| Str "superspace";|];
|]

and mathspace = Opts [|
  [| Str "AdS_"; n;|];
  [| Str "S^"; n;|];
  [| Str "R^"; n;|];
  [| Str "CY_"; n;|];
  [| Str "C^"; n;|];
  [| Str "dS_"; n;|];
  [| Str "T^"; n;|];
  [| mathspace; Str " x "; mathspace;|];
  [| Str "P^"; n;|];
|]

and spacepart = Opts [|
  [| Str "boundary";|];
  [| Str "conformal boundary";|];
  [| Str "null future";|];
  [| Str "horizon";|];
  [| Str "NUT";|];
|]

and mapping = Opts [|
  [| Str "function";|];
  [| Str "mapping";|];
  [| Str "homomorphism";|];
  [| Str "homeomorphism";|];
  [| Str "isomorphism";|];
  [| Str "surjective "; mapping;|];
  [| Str "injective "; mapping;|];
  [| Str "holomorphism";|];
  [| Str "biholomorphism";|];
  [| Str "isometry";|];
|]

and mathadj = Opts [|
  [| Str "trivial";|];
  [| Str "nontrivial";|];
  [| Str "zero";|];
  [| Str "nonzero";|];
  [| Str "general";|];
  [| Str "discrete";|];
  [| Str "abelian";|];
  [| Str "non-abelian";|];
  [| Str "equivariant";|];
  [| symmetry; Str " symmetric";|];
|]

and mathobj = Opts [|
  [| Str "fundamental group";|];
  [| Str "cohomology";|];
  [| Str "homology";|];
  [| Str "torsion";|];
  [| Str "monodromy";|];
  [| Str "spin-structure";|];
  [| Str "dimension";|];
  [| Str "complex-structure";|];
  [| Str "flux";|];
  [| Str "B-field";|];
  [| Str "H-flux";|];
|]

and representation = Opts [|
  [| Str "adjoint";|];
  [| Str "symmetric tensor";|];
  [| Str "antisymmetric tensor";|];
  [| Str "singlet";|];
  [| Str "doublet";|];
  [| Str "triplet";|];
|]

and theory = Opts [|
  [| singtheory;|];
  [| pluraltheory;|];
|]

and singtheory = Opts [|
  [| singqft; Str " "; theorymodifier;|];
  [| singstringtheory; Str " "; theorymodifier;|];
|]

and pluraltheory = Opts [|
  [| pluralqft; Str " "; theorymodifier;|];
  [| pluralstringtheory; Str " "; theorymodifier;|];
|]

and theorymodifier = Opts [|
  [||];
  [||];
  [| compactified; Str " on "; space;|];
  [| Str "deformed by "; operator; Str "s";|];
  [| Str "on "; space;|];
  [| near; Str " "; theoryobj;|];
|]

and compactified = Opts [|
  [| Str "living";|];
  [| Str "compactified";|];
  [| Str "dimensionally reduced";|];
  [| Str "supported";|];
|]

and near = Opts [|
  [| Str "in the presence of";|];
  [| Str "near";|];
  [| Str "surrounded by";|];
  [| Str "far from";|];
|]

and qft = Opts [|
  [| singqft;|];
  [| singqft;|];
  [| singqft;|];
  [| pluralqft;|];
|]

and singqft = Opts [|
  [| properqft;|];
  [| qftadj; Str " "; properqft;|];
  [| properqft; Str " "; qftproperty;|];
  [| Str "a "; qftadj; Str " "; genericqft;|];
|]

and pluralqft = Opts [|
  [| qftadj; Str " "; genericqft; Str "s";|];
|]

and qftadj = Opts [|
  [||];
  [| qftadj; Str " "; qftadj;|];
  [| Str "supersymmetric";|];
  [| Str "N="; nzdigit;|];
  [| Str "adjoint";|];
  [| Str "superconformal";|];
  [| Str "conformal";|];
  [| Str "extremal";|];
  [| Str "chiral";|];
  [| Str "topological";|];
  [| n; Str "-dimensional";|];
  [| Str "twisted";|];
  [| Str "topologically twisted";|];
  [| Str "deformed";|];
  [| Str "perturbative";|];
  [| Str "nonperturbative";|];
  [| Str "Toda";|];
  [| Str "WZW";|];
|]

and qftproperty = Opts [|
  [| Str "with "; qftobj;|];
|]

and qftobj = Opts [|
  [| Str "a "; operator;|];
  [| operator; Str "s";|];
  [| mathadj; Str " superpotential";|];
  [| mathadj; Str " kahler potential";|];
  [| representation; Str " "; field; Str "s";|];
  [| Str "a "; representation; Str " "; field;|];
  [| Str "gauge group "; liegroup;|];
  [| Str "a "; mathadj; Str " deformation";|];
  [| Str "a "; optype; Str " defect";|];
|]

and genericqft = Opts [|
  [| Str "QFT";|];
  [| Str "CFT";|];
  [| Str "Matrix Model";|];
  [| Str "TQFT";|];
  [| theorytype; Str " Theory";|];
|]

and theorytype = Opts [|
  [| Str "Effective Field";|];
  [| Str "Quantum Field";|];
  [| Str "Conformal Field";|];
  [| Str "Soft-Collinear Effective";|];
  [| Str "Topological Field";|];
  [| Str "Heavy Quark Effective";|];
  [| Str "low-energy Effective";|];
  [| Str "String";|];
  [| Str "Yang-Mills";|];
  [| Str "Chern-Simons";|];
  [| Str "gauge";|];
|]

and properqft = Opts [|
  [| Str "QCD";|];
  [| Str "QED";|];
  [| Str "supergravity";|];
  [| Str "unparticle physics";|];
|]

and stringtheory = Opts [|
  [| singstringtheory;|];
  [| pluralstringtheory;|];
|]

and singstringtheory = Opts [|
  [| Str "String Theory";|];
  [| Str "F-Theory";|];
  [| Str "M-Theory";|];
  [| Str "Heterotic string theory";|];
  [| Str "Topological String Theory";|];
  [| Str "type IIA";|];
  [| Str "type IIB";|];
|]

and pluralstringtheory = Opts [|
  [| Str "String theories";|];
  [| Str "Heterotic strings";|];
  [| Str "type IIA strings";|];
  [| Str "type IIB strings";|];
  [| Str "type I strings";|];
  [| Str "topological strings";|];
  [| Str "bosonic strings";|];
|]

and theoryobj = Opts [|
  [| singtheoryobj;|];
  [| pluraltheoryobj;|];
|]

and singtheoryobj = Opts [|
  [| Str "a "; bhadj; Str " black hole";|];
  [| Str "a "; singularityadj; Str " singularity";|];
  [| Str "a "; branetype; Str " brane "; braneaction;|];
  [| Str "a stack of "; branetype; Str " branes "; braneaction;|];
  [| Str "a "; generalspacetype; Str " defect";|];
  [| Str "an instanton";|];
  [| Str "an orientifold plane";|];
  [| Str "a "; branetype; Str " instanton";|];
  [| Str "a "; branetype; Str " brane probe";|];
|]

and pluraltheoryobj = Opts [|
  [| bhadj; Str " black holes";|];
  [| singularityadj; Str " singularities";|];
  [| branetype; Str " branes "; braneaction;|];
  [| generalspacetype; Str " defects";|];
  [| Str "orientifold planes";|];
  [| branetype; Str " instantons";|];
  [| Str "instantons";|];
|]

and bhadj = Opts [|
  [| Str "orientifold";|];
  [| Str "BTZ";|];
  [| Str "Kerr";|];
  [| Str "Reisner-Nordstrom";|];
  [| Str "small";|];
  [| Str "large";|];
  [| Str "Schwarzschild";|];
  [| branetype; Str " brane";|];
  [| Str "massive";|];
  [| Str "extremal";|];
|]

and singularityadj = Opts [|
  [| Str "A_"; n;|];
  [| Str "B_"; n;|];
  [| Str "C_"; n;|];
  [| Str "D_"; n;|];
  [| Str "E_6";|];
  [| Str "E_7";|];
  [| Str "E_8";|];
  [| Str "G_2";|];
  [| Str "F_4";|];
  [| Str "conifold";|];
  [| Str "conical";|];
  [| Str "ADE";|];
  [| Str "orbifold";|];
  [| Str "du Val";|];
  [| Str "Kleinian";|];
  [| Str "rational double-point";|];
  [| Str "canonical";|];
  [| Str "exceptional";|];
  [| physicist;|];
|]

and branetype = Opts [|
  [| Str "NS5";|];
  [| Str "D"; nzdigit;|];
  [| Str "(p,q) 7-";|];
  [| Str "(p,q)";|];
  [| Str "noncommutative";|];
  [| Str "black";|];
  [| Str "fractional D"; nzdigit;|];
  [| Str "special lagrangian";|];
  [| Str "canonical co-isotropic";|];
  [| Str "holomorphic";|];
  [| Str "A-type";|];
  [| Str "B-type";|];
|]

and braneaction = Opts [|
  [||];
  [| Str "wrapping a "; mathspace;|];
  [| Str "wrapped on "; singspace;|];
|]

and operator = Opts [|
  [| optype; Str " operator";|];
  [| Str "Chern-Simons term";|];
  [| optype; Str " F-term";|];
  [| Str "Wilson line";|];
  [| Str "'t Hooft line";|];
  [| generalspacetype; Str " operator";|];
  [| optype; Str " D-term";|];
|]

and optype = Opts [|
  [| Str "primary";|];
  [| Str "quasi-primary";|];
  [| Str "marginal";|];
  [| Str "relevant";|];
  [| Str "irrelevant";|];
  [| Str "four-quark";|];
  [| Str "multi-fermion";|];
  [| Str "loop";|];
  [| Str "local";|];
  [| Str "nonlocal";|];
  [| Str "BPS";|];
|]

and field = Opts [|
  [| Str "boson";|];
  [| Str "fermion";|];
  [| Str "gauge-field";|];
  [| n; Str "-form";|];
  [| Str "scalar";|];
|]

and objectplace = Opts [|
  [| Str "at the center of the galaxy";|];
  [| Str "in our solar system";|];
  [| Str "on the surface of the sun";|];
  [| Str "at the edge of our universe";|];
  [| Str "in the CMB";|];
  [| Str "at the LHC";|];
  [| Str "at the Tevatron";|];
  [| Str "at SNO";|];
  [| Str "at ATLAS";|];
  [| Str "in the interstellar medium";|];
  [| Str "at DAMA";|];
  [| Str "at CDMS";|];
  [| Str "in the early universe";|];
  [| Str "during inflation";|];
  [| Str "after reheating";|];
  [| Str "at the GUT scale";|];
  [| Str "at the weak scale";|];
  [| Str "at $\\Lambda_{QCD}$";|];
  [| Str "at the intermediate scale";|];
  [| Str "at the Planck scale";|];
|]

and model = Opts [|
  [| singmodel;|];
  [| pluralmodel;|];
|]

and singmodel = Opts [|
  [| Str "a model of "; physsubject;|];
  [| Str "a model for "; physsubject;|];
  [| Str "a "; physadj; Str " model "; modelmodifier;|];
  [| Str "the "; propermodel;|];
  [| Str "the "; physadj; Str " "; propermodel;|];
  [| physadj; Str " "; generalmodel;|];
  [| inflationadj; Str " inflation";|];
  [| generalmodel;|];
  [| generalmodel;|];
  [| physicist; Str " "; generalmodel;|];
|]

and pluralmodel = Opts [|
  [| Str "models of "; physsubject;|];
  [| physadj; Str " models "; modelmodifier;|];
  [| Str "models of "; particle; Str "s";|];
|]

and modelmodifier = Opts [|
  [||];
  [| Str "of "; physsubject;|];
  [| Str "for "; physsubject;|];
  [| Str "with "; particle; Str "s";|];
|]

and propermodel = Opts [|
  [| Str "Standard Model";|];
  [| Str "MSSM";|];
  [| nnnn; Str "MSSM";|];
  [| Str "Thirring Model";|];
  [| Str "Ising Model";|];
  [| Str "XXZ Model";|];
  [| Str "O(n) Model";|];
  [| physicist; Str " Model";|];
  [| Str "Landau-Ginzburg Model";|];
  [| Str "A-model";|];
  [| Str "B-model";|];
|]

and nnnn = Opts [|
  [| Str "N";|];
  [| Str "N"; nnnn;|];
|]

and generalmodel = Opts [|
  [| Str "gravity";|];
  [| Str "general relativity";|];
  [| Str "RS1";|];
  [| Str "RS2";|];
  [| Str "technicolor";|];
  [| Str "gauge mediation";|];
  [| Str "anomaly mediation";|];
  [| properqft;|];
  [| dynadjective; Str " mechanics";|];
  [| dynadjective; Str " dynamics";|];
  [| Str "hydrodynamics";|];
  [| Str "thermodynamics";|];
  [| Str "unparticle physics";|];
|]

and dynadjective = Opts [|
  [| Str "quantum";|];
  [| physicist;|];
  [| physadj;|];
|]

and physadj = Opts [|
  [| physadj; Str " "; physadj;|];
  [| Str "non-"; physadj;|];
  [| nondescriptivephysadj;|];
  [| descriptivephysadj;|];
  [| nondescriptivephysadj;|];
  [| descriptivephysadj;|];
  [| nondescriptivephysadj;|];
  [| descriptivephysadj;|];
  [| nondescriptivephysadj;|];
  [| descriptivephysadj;|];
  [| nondescriptivephysadj;|];
  [| descriptivephysadj;|];
  [| nondescriptivephysadj;|];
  [| descriptivephysadj;|];
  [| nondescriptivephysadj;|];
  [| descriptivephysadj;|];
|]

and nondescriptivephysadj = Opts [|
  [| Str "seesaw";|];
  [| Str "curvaton";|];
  [| Str "hybrid";|];
  [| Str "quantum";|];
  [| Str "loop";|];
  [| Str "cosmon";|];
  [| Str "scalar";|];
  [| particle;|];
  [| physsubject;|];
  [| Str "isocurvature";|];
  [| branetype; Str " brane";|];
  [| Str "condensate";|];
  [| Str "three-fluid";|];
  [| Str "multi-field";|];
  [| Str "variable mass";|];
  [| Str "particle";|];
  [| Str "matrix";|];
  [| Str "lattice";|];
  [| Str "inflaton";|];
  [| Str "bulk";|];
  [| Str "boundary";|];
  [| Str "halo";|];
  [| Str "braneworld";|];
  [| Str "GUT";|];
  [| liegroup;|];
  [| Str "scalar field";|];
  [| Str "RS";|];
  [| Str "flavor";|];
  [| Str "Landau-Ginzburg";|];
  [| Str "Planck";|];
  [| physicist;|];
  [| Str "left-right";|];
  [| Str "large-N";|];
  [| Str "parent";|];
  [| Str "QCD";|];
  [| Str "QED";|];
  [| Str "BPS";|];
  [| Str "unparticle";|];
  [| Str "high-scale";|];
  [| Str "low-scale";|];
  [| Str "large mass";|];
|]

and descriptivephysadj = Opts [|
  [| Str "non-gaussian";|];
  [| Str "simple";|];
  [| Str "inflationary";|];
  [| inflationadj; Str " inflationary";|];
  [| Str "exactly-soluble";|];
  [| Str "unified";|];
  [| Str "minimal";|];
  [| Str "quantum";|];
  [| Str "linear";|];
  [| Str "nonlinear";|];
  [| Str "gravitational";|];
  [| Str "quantum gravitational";|];
  [| Str "cosmological";|];
  [| Str "supersymmetric";|];
  [| Str "holographic";|];
  [| Str "entropic";|];
  [| Str "alternative";|];
  [| Str "nonstandard";|];
  [| Str "multidimensional";|];
  [| Str "nonlocal";|];
  [| Str "chiral";|];
  [| Str "phenomenological";|];
  [| Str "nonperturbative";|];
  [| Str "perturbative";|];
  [| Str "warped";|];
  [| n; Str "-dimensional";|];
  [| Str "conformal";|];
  [| Str "modified";|];
  [| Str "supergravity mediated";|];
  [| Str "gauge mediated";|];
  [| Str "anomaly mediated";|];
  [| Str "superconformal";|];
  [| Str "extra-ordinary";|];
  [| Str "general";|];
  [| Str "anthropic";|];
  [| Str "nilpotent";|];
  [| Str "asymmetric";|];
  [| symmetry; Str " symmetric";|];
  [| symmetry; Str " invariant";|];
  [| Str "spontaneous";|];
  [| Str "thermodynamic";|];
  [| Str "planar";|];
  [| Str "inertial";|];
  [| Str "metastable";|];
  [| Str "unstable";|];
  [| Str "tachyonic";|];
  [| Str "transverse";|];
  [| Str "longitudinal";|];
  [| Str "momentum-dependent";|];
  [| Str "exclusive";|];
  [| Str "diffractive";|];
  [| Str "dynamical";|];
  [| Str "effective";|];
  [| Str "acoustic";|];
  [| Str "primordial";|];
  [| Str "possible";|];
  [| Str "impossible";|];
  [| Str "calculable";|];
  [| Str "predictive";|];
  [| Str "unconventional";|];
  [| Str "macroscopic";|];
  [| Str "microscopic";|];
  [| Str "holomorphic";|];
  [| Str "consistent";|];
  [| Str "inconsistent";|];
  [| Str "anomalous";|];
|]

and inflationadj = Opts [|
  [| inflationadj; Str " "; inflationadj;|];
  [| inflationadj; Str " "; inflationadj;|];
  [| inflationadj; Str " "; inflationadj;|];
  [| inflationadj; Str " "; inflationadj;|];
  [| Str "$D$-Term";|];
  [| Str "anisotropic";|];
  [| Str "asymptotic";|];
  [| Str "brane";|];
  [| Str "braneworld chaotic";|];
  [| Str "Brans-Dicke";|];
  [| Str "chaotic";|];
  [| Str "cosmological";|];
  [| Str "de Sitter";|];
  [| Str "double";|];
  [| Str "dynamical";|];
  [| Str "elastic";|];
  [| Str "extended";|];
  [| Str "extranatural";|];
  [| Str "F-term";|];
  [| Str "hybrid";|];
  [| Str "false vacuum";|];
  [| Str "first-order";|];
  [| Str "general";|];
  [| Str "generalized assisted";|];
  [| Str "higher-curvature";|];
  [| Str "hyper";|];
  [| Str "inflatonless";|];
  [| Str "inspired";|];
  [| Str "inverted";|];
  [| Str "K";|];
  [| Str "large-scale";|];
  [| Str "late-time";|];
  [| Str "mild";|];
  [| Str "low scale";|];
  [| Str "modular invariant";|];
  [| Str "multi-component";|];
  [| Str "multi-field stochastic";|];
  [| Str "multi-field";|];
  [| Str "mutated";|];
  [| Str "natural";|];
  [| Str "new";|];
  [| Str "$\\Omega"; Str "<1$";|];
  [| Str "assisted";|];
  [| Str "brane-assisted";|];
  [| Str "tachyonic";|];
  [| Str "liouville";|];
  [| Str "open";|];
  [| Str "Cobe-Dmr-normalized";|];
  [| Str "D-term";|];
  [| Str "dissipative";|];
  [| Str "supersymmetric";|];
  [| Str "eternal";|];
  [| Str "extended";|];
  [| Str "extreme";|];
  [| Str "facilitated";|];
  [| Str "warm";|];
  [| Str "generalized";|];
  [| Str "gravitoelectromagnetic";|];
  [| Str "holographic";|];
  [| Str "induced";|];
  [| Str "inhomogeneous";|];
  [| Str "intermediate";|];
  [| Str "kinetic";|];
  [| Str "local";|];
  [| Str "mass";|];
  [| Str "moduli";|];
  [| Str "slow-roll";|];
  [| Str "multi-scalar";|];
  [| Str "supergravity";|];
  [| Str "natural";|];
  [| Str "boundary";|];
  [| Str "cosmic";|];
  [| Str "dominated";|];
  [| Str "early";|];
  [| Str "exact";|];
  [| Str "fake";|];
  [| Str "field line";|];
  [| Str "fresh";|];
  [| Str "gravity driven";|];
  [| Str "induced-gravity";|];
  [| Str "intermediate scale";|];
  [| Str "Jordan-Brans-Dicke";|];
  [| Str "large field";|];
  [| Str "locked";|];
  [| Str "massive";|];
  [| Str "monopole";|];
  [| Str "multiple";|];
  [| Str "multiple-stage";|];
  [| Str "supergravity";|];
  [| Str "non-slow-roll";|];
  [| Str "old";|];
  [| Str "particle physics";|];
  [| Str "pole-like";|];
  [| Str "power-law mass";|];
  [| Str "precise";|];
  [| Str "pseudonatural";|];
  [| Str "quasi-open";|];
  [| Str "racetrack";|];
  [| Str "running-mass";|];
  [| Str "simple";|];
  [| Str "single scalar";|];
  [| Str "single-bubble";|];
  [| Str "spacetime";|];
  [| Str "noncommutative";|];
  [| Str "standard";|];
  [| Str "steady-state";|];
  [| Str "successful";|];
  [| Str "sunergistic";|];
  [| Str "tensor field";|];
  [| Str "thermal brane";|];
  [| Str "tilted ghost";|];
  [| Str "topological";|];
  [| Str "tsunami";|];
  [| Str "unified";|];
  [| Str "weak scale";|];
  [| Str "noise-induced";|];
  [| Str "one-bubble";|];
  [| Str "open-universe";|];
  [| Str "patch";|];
  [| Str "polynomial";|];
  [| Str "primary";|];
  [| Str "quadratic";|];
  [| Str "quintessential";|];
  [| Str "rapid";|];
  [| Str "asymmetric";|];
  [| Str "scalar-tensor";|];
  [| Str "non-canonical";|];
  [| Str "smooth";|];
  [| Str "spin-driven";|];
  [| Str "Starobinsky";|];
  [| Str "stochastic";|];
  [| Str "string-forming";|];
  [| Str "TeV-scale";|];
  [| Str "three form";|];
  [| Str "topological defect";|];
  [| Str "viable";|];
  [| Str "weak-dissipative";|];
  [| Str "nonminimal";|];
  [| Str "oscillating";|];
  [| Str "phantom";|];
  [| Str "power law";|];
  [| Str "pre-big-bang";|];
  [| Str "primordial";|];
  [| Str "quantum";|];
  [| Str "R-invariant";|];
  [| Str "running";|];
  [| Str "shear-free";|];
  [| Str "rotating";|];
  [| Str "slinky";|];
  [| Str "spinodal";|];
  [| Str "thermal";|];
  [| Str "tidal";|];
  [| Str "tree-level";|];
  [| Str "two-stage";|];
  [| Str "anthropic";|];
|]

and physicist = Opts [|
  [| physicistname;|];
  [| physicistname;|];
  [| physicistname; Str "-"; physicistname;|];
|]

and physicistname = Opts [|
  [| Str "Weinberg";|];
  [| Str "Feynman";|];
  [| Str "Witten";|];
  [| Str "Seiberg";|];
  [| Str "Polchinski";|];
  [| Str "Intrilligator";|];
  [| Str "Vafa";|];
  [| Str "Randall";|];
  [| Str "Sundrum";|];
  [| Str "Strominger";|];
  [| Str "Georgi";|];
  [| Str "Glashow";|];
  [| Str "Coleman";|];
  [| Str "Bohr";|];
  [| Str "Fermi";|];
  [| Str "Heisenberg";|];
  [| Str "Maldacena";|];
  [| Str "Einstein";|];
  [| Str "Kachru";|];
  [| Str "Arkani-Hamed";|];
  [| Str "Schwinger";|];
  [| Str "Higgs";|];
  [| Str "Hitchin";|];
  [| Str "Hawking";|];
  [| Str "Stueckelberg";|];
  [| Str "Unruh";|];
  [| Str "Aranov-Bohm";|];
  [| Str "'t Hooft";|];
  [| Str "Silverstein";|];
  [| Str "Horava";|];
  [| Str "Lifschitz";|];
  [| Str "Beckenstein";|];
  [| Str "Planck";|];
  [| Str "Euler";|];
  [| Str "Lagrange";|];
  [| Str "Maxwell";|];
  [| Str "Boltzmann";|];
  [| Str "Lorentz";|];
  [| Str "Poincare";|];
  [| Str "Susskind";|];
  [| Str "Polyakov";|];
  [| Str "Gell-Mann";|];
  [| Str "Penrose";|];
  [| Str "Dyson";|];
  [| Str "Dirac";|];
  [| Str "Argyres";|];
  [| Str "Douglass";|];
  [| Str "Gross";|];
  [| Str "Politzer";|];
  [| Str "Cabibo";|];
  [| Str "Kobayashi";|];
  [| Str "Denef";|];
  [| Str "Shenker";|];
  [| Str "Moore";|];
  [| Str "Nekrosov";|];
  [| Str "Gaiotto";|];
  [| Str "Motl";|];
  [| Str "Strassler";|];
  [| Str "Klebanov";|];
  [| Str "Nelson";|];
  [| Str "Gubser";|];
  [| Str "Verlinde";|];
  [| Str "Bogoliubov";|];
  [| Str "Schwartz";|];
|]

and mathconcept = Opts [|
  [| singmathconcept;|];
  [| pluralmathconcept;|];
|]

and singmathconcept = Opts [|
  [| Str "integrability";|];
  [| Str "perturbation theory";|];
  [| Str "localization";|];
  [| Str "duality";|];
  [| Str "chaos";|];
  [| mathadj; Str " structure";|];
  [| physicist; Str "'s equation";|];
  [| Str "dimensionality";|];
  [| dualtype; Str "-duality";|];
  [| Str "unitarity";|];
  [| Str "representation theory";|];
  [| Str "Clebsch-Gordon decomposition";|];
  [| Str "sheaf cohomology";|];
  [| Str "anomaly matching";|];
|]

and pluralmathconcept = Opts [|
  [| Str "gerbs";|];
  [| Str "path integrals";|];
  [| Str "Feynman diagrams";|];
  [| mathadj; Str " structures";|];
  [| physicist; Str " equations";|];
  [| physicistname; Str "'s equations";|];
  [| Str "conformal blocks";|];
  [| optype; Str " operators";|];
  [| dualtype; Str "-dualities";|];
  [| physicist; Str " points";|];
  [| group; Str " characters";|];
  [| Str "central charges";|];
  [| Str "charges";|];
  [| Str "currents";|];
  [| Str "representations";|];
  [| physicist; Str " conditions";|];
  [| Str "symplectic quotients";|];
  [| Str "hyperkahler quotients";|];
  [| Str "Nahm's equations";|];
  [| Str "vortices";|];
  [| Str "vortex equations";|];
  [| Str "Hilbert schemes";|];
  [| Str "integration cycles";|];
  [| Str "divisors";|];
  [| Str "line bundles";|];
  [| Str "index theorems";|];
  [| Str "flow equations";|];
  [| Str "metrics";|];
  [| Str "Gromov-Witten invariants";|];
  [| Str "Gopakumar-Vafa invariants";|];
  [| Str "Donaldson polynomials";|];
|]

and physconcept = Opts [|
  [| pluralphysconcept;|];
  [| singphysconcept;|];
|]

and pluralphysconcept = Opts [|
  [| Str "examples of "; physconcept;|];
  [| Str "equations of "; theory;|];
  [| n; Str "-point correlators";|];
  [| symmetry; Str " algebras";|];
  [| Str "fragmentation functions";|];
  [| Str "decay constants";|];
  [| Str "anomaly constraints";|];
  [| Str "anomalous dimensions";|];
  [| Str "PDFs";|];
  [| Str "observables";|];
  [| Str "effects of "; physconcept;|];
  [| Str "partition functions";|];
  [| particle; Str " collisions";|];
  [| physadj; Str " effects";|];
  [| physadj; Str " parameters";|];
  [| physadj; Str " hierarchies";|];
  [| physconceptnoun;|];
  [| physadj; Str " "; physconceptnoun;|];
  [| Str "amplitudes";|];
  [| Str "scattering amplitudes";|];
  [| Str "geometric transitions";|];
|]

and singphysconcept = Opts [|
  [| symmviol; Str " "; symmetry; Str " invariance";|];
  [| symmviol; Str " "; symmetry; Str " symmetry";|];
  [| symmetry; Str " symmetry breaking";|];
  [| mechanism;|];
  [| Str "confinement";|];
  [| Str "the "; physadj; Str " limit";|];
  [| Str "the "; physadj; Str " law";|];
  [| Str "the "; symmetry; Str " algebra";|];
  [| Str "the beta function";|];
  [| Str "the Wilsonian effective action";|];
  [| Str "the "; n; Str "PI effective action";|];
  [| Str "the partition function";|];
  [| particle; Str " production";|];
  [| Str "the effective potential";|];
  [| Str "renormalization";|];
  [| Str "regularization";|];
  [| Str "backreaction";|];
  [| Str "AdS/CFT";|];
  [| Str "the partition function";|];
  [| Str "a "; physadj; Str " hierarchy";|];
  [| Str "the "; physicist; Str " formalism";|];
  [| Str "the "; physadj; Str " formalism";|];
  [| physadj; Str " regularization";|];
  [| Str "the 't Hooft anomaly matching condition";|];
  [| Str "the S-matrix";|];
  [| Str "the Hamiltonian";|];
  [| Str "the Lagrangian";|];
  [| Str "the omega deformation";|];
  [| Str "the "; physadj; Str " Hilbert space";|];
  [| Str "the Hilbert space";|];
  [| Str "\""; singphysconcept; Str "\"";|];
  [| effect;|];
  [| Str "the OPE";|];
  [| Str "IR behavior";|];
  [| Str "UV behavior";|];
  [| Str "a warped throat";|];
  [| Str "a holographic superconductor";|];
  [| Str "the "; particle; Str " charge";|];
  [| Str "the "; particle; Str " gyromagnetic ratio";|];
|]

and physconceptnoun = Opts [|
  [| Str "sectors";|];
  [| Str "vacua";|];
  [| Str "solutions";|];
  [| Str "states";|];
  [| Str "geometries";|];
  [| Str "currents";|];
  [| Str "backgrounds";|];
  [| Str "wavefunctions";|];
  [| Str "excitations";|];
  [| Str "branching ratios";|];
  [| Str "amplitudes";|];
  [| Str "decays";|];
  [| Str "exotics";|];
  [| Str "corrections";|];
  [| Str "interactions";|];
  [| Str "inhomogeneities";|];
  [| Str "correlation functions";|];
|]

and dualtype = Opts [|
  [| Str "T";|];
  [| Str "U";|];
  [| Str "S";|];
  [| Str "magnetic";|];
  [| Str "electric";|];
  [| Str "gravitational";|];
  [| Str "boundary";|];
  [| Str "Seiberg";|];
  [| Str "Geometric Langlands";|];
|]

and symmviol = Opts [|
  [||];
  [| Str "violation of";|];
  [| physadj; Str " violation of";|];
  [| Str "breaking of";|];
|]

and symmetry = Opts [|
  [| Str "dilation";|];
  [| Str "translation";|];
  [| Str "rotation";|];
  [| Str "Lorentz";|];
  [| Str "conformal";|];
  [| Str "superconformal";|];
  [| Str "super";|];
  [| Str "Poincare";|];
  [| Str "worldsheet";|];
  [| Str "diffeomorphism";|];
  [| Str "superdiffeomorphism";|];
  [| liegroup;|];
  [| Str "dual-superconformal";|];
  [| Str "Yangian";|];
  [| Str "Virosoro";|];
|]

and mechanism = Opts [|
  [| Str "the "; mechanismadj; Str " mechanism";|];
  [| Str "the "; physadj; Str " "; mechanismadj; Str " mechanism";|];
|]

and mechanismadj = Opts [|
  [| Str "Higgs";|];
  [| Str "seesaw";|];
  [| physicist;|];
  [| Str "attractor";|];
  [| Str "anomaly inflow";|];
  [| Str "reheating";|];
  [| Str "SuperHiggs";|];
  [| Str "confinement";|];
|]

and effect = Opts [|
  [| Str "the "; effectadj; Str " effect";|];
  [| Str "the "; physadj; Str " "; effectadj; Str " effect";|];
  [| physadj; Str " effects";|];
|]

and effectadj = Opts [|
  [| physicist;|];
  [| Str "quantum Hall";|];
  [| Str "Unruh";|];
  [| Str "Stark";|];
  [| Str "Casimir";|];
|]

and physsubject = Opts [|
  [| singphyssubject;|];
  [| pluralphyssubject;|];
|]

and singphyssubject = Opts [|
  [| Str "quintessence";|];
  [| inflationadj; Str " inflation";|];
  [| Str "inflation";|];
  [| Str "dark matter";|];
  [| Str "dark energy";|];
  [| Str "spacetime foam";|];
  [| Str "instanton gas";|];
  [| Str "entropy";|];
  [| Str "entanglement entropy";|];
  [| Str "flavor";|];
  [| Str "bubble nucleation";|];
|]

and pluralphyssubject = Opts [|
  [| Str "condensates";|];
  [| branetype; Str " branes";|];
  [| Str "cosmic rays";|];
  [| Str "instanton liquids";|];
  [| physadj; Str " fluctuations";|];
  [| Str "bubbles";|];
|]

and particle = Opts [|
  [| Str "hadron";|];
  [| Str "lepton";|];
  [| Str "quark";|];
  [| Str "neutrino";|];
  [| Str "electron";|];
  [| Str "positron";|];
  [| Str "WIMP";|];
  [| Str "slepton";|];
  [| Str "squark";|];
  [| Str "kk graviton";|];
  [| Str "gluon";|];
  [| Str "W-boson";|];
  [| Str "Z-boson";|];
  [| Str "neutralino";|];
  [| Str "chargino";|];
  [| Str "ghost";|];
  [| Str "axion";|];
  [| Str "monopole";|];
  [| Str "soliton";|];
  [| Str "dion";|];
  [| Str "kaon";|];
  [| Str "B-meson";|];
  [| Str "pion";|];
  [| Str "heavy-ion";|];
  [| Str "Higgs";|];
|]

and subject = Opts [|
  [| singsubject;|];
  [| pluralsubject;|];
|]

and pluralsubject = Opts [|
  [| pluralmodel;|];
  [| pluraltheoryobj;|];
  [| particle; Str "s";|];
  [| pluralphysconcept; Str " in "; modeltheory;|];
  [| pluralmathconcept; Str " in "; theory;|];
  [| mathadj; Str " "; pluralmathconcept;|];
  [| pluralphysconcept;|];
  [| pluraltheory;|];
  [| pluralphyssubject; Str " "; objectplace;|];
  [| pluraltheoryobj; Str " "; objectplace;|];
  [| Str "some "; specific; Str " "; examples;|];
  [| pluralmathconcept; Str " on "; space;|];
|]

and specific = Opts [|
  [| Str "specific";|];
  [| Str "general";|];
  [| Str "particular";|];
  [| Str "conspicuous";|];
  [| Str "little-known";|];
|]

and examples = Opts [|
  [| Str "cases";|];
  [| Str "examples";|];
  [| Str "illustrations";|];
  [| Str "computations";|];
  [| Str "frameworks";|];
  [| Str "paradigms";|];
|]

and singsubject = Opts [|
  [| singmodel;|];
  [| singtheory;|];
  [| singtheoryobj;|];
  [| problem;|];
  [| solution;|];
  [| studyingverb; Str " "; modeltheory;|];
  [| article; Str " "; physadj; Str " "; actiondone; Str " of "; modeltheory;|];
  [| singphysconcept; Str " in "; modeltheory;|];
  [| singmathconcept; Str " in "; theory;|];
  [| mathadj; Str " "; singmathconcept;|];
  [| singphysconcept;|];
  [| Str "the "; actiondone; Str " of "; modeltheory;|];
  [| article; Str " "; actiondone; Str " of "; mathconcept; Str " in "; modeltheory;|];
  [| Str "the "; correspondent; Str "/"; correspondent; Str " correspondence";|];
  [| article; Str " "; dualtype; Str "-dual of "; modeltheory;|];
  [| dualtype; Str "-duality in "; modeltheory;|];
  [| singtheoryobj; Str " "; objectplace;|];
  [| singphyssubject; Str " "; objectplace;|];
  [| singsubject; Str " ("; including; Str " "; subject; Str ")";|];
  [| singmathconcept; Str " on "; space;|];
  [| singmathconcept;|];
  [| Str "a certain notion of "; singmathconcept;|];
|]

and modeltheory = Opts [|
  [| model;|];
  [| theory;|];
|]

and including = Opts [|
  [| Str "including";|];
  [| Str "excluding";|];
  [| Str "involving";|];
  [| Str "taking into account";|];
|]

and correspondent = Opts [|
  [| generalmodel;|];
  [| propermodel;|];
  [| properqft;|];
  [| genericqft;|];
  [| mathspace;|];
|]

and solution = Opts [|
  [| article; Str " solution "; solved;|];
  [| article; Str " "; soladj; Str " solution "; solved;|];
  [| article; Str " solution "; solved; Str " "; via; Str " "; subject;|];
  [| article; Str " "; soladj; Str " solution "; solved; Str " "; via; Str " "; subject;|];
  [| Str "a resolution of "; problem;|];
  [| Str "a "; soladj; Str " resolution of "; problem;|];
  [| Str "a "; soladj; Str " approach to "; problem;|];
|]

and solved = Opts [|
  [| Str "to "; problem;|];
  [| Str "of "; theory;|];
|]

and via = Opts [|
  [| Str "via";|];
  [| Str "through";|];
  [| Str "from";|];
  [| Str "by";|];
|]

and soladj = Opts [|
  [| Str "better";|];
  [| Str "new";|];
  [| Str "beautiful";|];
  [| Str "quantum";|];
  [| Str "physical";|];
  [| Str "old";|];
  [| Str "clever";|];
  [| Str "minimal";|];
  [| Str "non-minimal";|];
  [| physadj;|];
  [| Str "anthropic";|];
  [| Str "entropic";|];
  [| Str "possible";|];
  [| Str "probable";|];
  [| Str "partial";|];
|]

and problem = Opts [|
  [| Str "the "; problemtype; Str " problem";|];
|]

and problemtype = Opts [|
  [| Str "hierarchy";|];
  [| Str "flavor";|];
  [| Str "cosmological constant";|];
  [| Str "lithium";|];
  [| Str "mu";|];
  [| Str "strong CP";|];
  [| Str "naturalness";|];
  [| Str "little hierarchy";|];
  [| Str "SUSY CP";|];
  [| Str "LHC inverse";|];
  [| Str "cosmic coincidence";|];
  [| Str "U(1)";|];
  [| Str "fine-tuning";|];
  [| Str "mu/B_mu";|];
  [| Str "confinement";|];
|]

and verb = Opts [|
  [| Str "derive";|];
  [| Str "obtain";|];
  [| Str "deduce";|];
  [| Str "discover";|];
  [| Str "find";|];
  [| Str "conjecture";|];
  [| Str "check";|];
  [| Str "calculate";|];
  [| Str "predict";|];
|]

and verbed = Opts [|
  [| Str "derived";|];
  [| Str "obtained";|];
  [| Str "deduced";|];
  [| Str "discovered";|];
  [| Str "found";|];
  [| Str "conjectured";|];
  [| Str "realized";|];
  [| Str "checked";|];
  [| Str "calculated";|];
  [| Str "predicted";|];
|]

and studyverb = Opts [|
  [| Str "study";|];
  [| Str "solve";|];
  [| Str "investigate";|];
  [| Str "demystify";|];
  [| Str "bound";|];
  [| Str "classify";|];
  [| Str "obtain";|];
  [| Str "derive";|];
  [| Str "generalize";|];
  [| Str "explore";|];
  [| Str "examine";|];
  [| Str "consider";|];
  [| Str "analyze";|];
  [| Str "evaluate";|];
  [| Str "review";|];
  [| Str "survey";|];
  [| Str "explain";|];
  [| Str "clarify";|];
  [| Str "shed light on";|];
  [| Str "extend";|];
  [| Str "construct";|];
  [| Str "reconstruct";|];
  [| Str "calculate";|];
  [| Str "discuss";|];
  [| Str "formulate";|];
  [| Str "reformulate";|];
  [| Str "understand";|];
|]

and studyingverb = Opts [|
  [| Str "studying";|];
  [| Str "solving";|];
  [| Str "investigating";|];
  [| Str "demystifying";|];
  [| Str "bounding";|];
  [| Str "classifying";|];
  [| Str "obtaining";|];
  [| Str "deriving";|];
  [| Str "generalizing";|];
  [| Str "exploring";|];
  [| Str "examining";|];
  [| Str "considering";|];
  [| Str "analyzing";|];
  [| Str "evaluating";|];
  [| Str "reviewing";|];
  [| Str "surveying";|];
  [| Str "explaining";|];
  [| Str "clarifying";|];
  [| Str "formulating";|];
  [| Str "reformulating";|];
  [| Str "extending";|];
  [| Str "constructing";|];
  [| Str "reconstructing";|];
  [| Str "discussing";|];
  [| Str "understanding";|];
|]

and studiedverb = Opts [|
  [| Str "studied";|];
  [| Str "solved";|];
  [| Str "investigated";|];
  [| Str "demystified";|];
  [| Str "bounded";|];
  [| Str "classified";|];
  [| Str "obtained";|];
  [| Str "derived";|];
  [| Str "generalized";|];
  [| Str "explored";|];
  [| Str "examined";|];
  [| Str "considered";|];
  [| Str "analyzed";|];
  [| Str "evaluated";|];
  [| Str "reviewed";|];
  [| Str "surveyed";|];
  [| Str "recalled";|];
  [| Str "explained";|];
  [| Str "clarified";|];
  [| Str "extended";|];
  [| Str "constructed";|];
  [| Str "reconstructed";|];
  [| Str "discussed";|];
  [| Str "understood";|];
|]

and singbeingverb = Opts [|
  [| Str "exists";|];
  [| Str "is present";|];
  [| Str "must be there";|];
  [| Str "must be present";|];
  [| Str "does not exist";|];
|]

and revealed = Opts [|
  [| Str "revealed";|];
  [| Str "produced";|];
  [| Str "led to";|];
  [| Str "led us to";|];
  [| Str "exposed";|];
  [| Str "uncovered";|];
|]

and singstatementverb = Opts [|
  [| Str "is";|];
  [| Str "is equivalent to";|];
  [| Str "is related to";|];
  [| Str "derives from";|];
  [| Str "reduces to";|];
  [| Str "follows from";|];
  [| Str "lets us "; studyverb;|];
  [| Str "can be interpreted as";|];
  [| Str "can be "; verbed; Str " from";|];
  [| Str "turns out to be equivalent to";|];
  [| Str "relates to";|];
  [| Str "depends on";|];
  [| adverb; Str " "; singstatementverb;|];
  [| Str "can be incorporated into";|];
  [| Str "can be brought to bear in "; studyingverb;|];
  [| Str "is useful for "; studyingverb;|];
  [| Str "is the final component in "; studyingverb;|];
|]

and pluralstatementverb = Opts [|
  [| Str "are the same as";|];
  [| Str "are equivalent to";|];
  [| Str "are related to";|];
  [| Str "let us "; studyverb;|];
  [| Str "can compute";|];
  [| Str "follow from";|];
  [| Str "can be interpreted as";|];
  [| Str "can be "; verbed; Str " from";|];
  [| Str "turn out to be equivalent to";|];
  [| Str "relate to";|];
  [| Str "depend on";|];
  [| Str "derive from";|];
  [| Str "reduce to";|];
  [| adverb; Str " "; pluralstatementverb;|];
  [| Str "can be incorporated into";|];
  [| Str "can be brought to bear in "; studyingverb;|];
  [| Str "are useful for "; studyingverb;|];
  [| Str "relate "; subject; Str " to";|];
|]

and yields = Opts [|
  [| Str "yields";|];
  [| Str "gives";|];
  [| Str "provides";|];
  [| Str "produces";|];
  [| Str "gives rise to";|];
|]

and prove = Opts [|
  [| Str "prove";|];
  [| Str "show";|];
  [| Str "demonstrate";|];
  [| Str "establish";|];
  [| Str "illustrate";|];
  [| Str "determine";|];
  [| Str "confirm";|];
  [| Str "verify";|];
|]

and contradict = Opts [|
  [| Str "contradict";|];
  [| Str "disagree with";|];
  [| Str "agree with";|];
  [| Str "find inconsistencies with";|];
  [| Str "argue against";|];
  [| Str "run counter to";|];
  [| Str "cannot corroborate";|];
  [| Str "cannot support";|];
  [| Str "challenge";|];
  [| Str "fail to "; prove;|];
|]

and capital = Opts [|
  [| Str "A";|];
  [| Str "B";|];
  [| Str "C";|];
  [| Str "D";|];
  [| Str "E";|];
  [| Str "F";|];
  [| Str "G";|];
  [| Str "H";|];
  [| Str "I";|];
  [| Str "J";|];
  [| Str "K";|];
  [| Str "L";|];
  [| Str "M";|];
  [| Str "N";|];
  [| Str "O";|];
  [| Str "P";|];
  [| Str "Q";|];
  [| Str "R";|];
  [| Str "S";|];
  [| Str "T";|];
  [| Str "U";|];
  [| Str "V";|];
  [| Str "W";|];
  [| Str "X";|];
  [| Str "Y";|];
  [| Str "Z";|];
|]

and article = Opts [|
  [| Str "a";|];
  [| Str "the";|];
|]

and adverb = Opts [|
  [| Str "remarkably";|];
  [| Str "actually";|];
  [| Str "interestingly";|];
  [| Str "however";|];
  [| Str "moreover";|];
  [| Str "therefore";|];
  [| Str "thus";|];
  [| Str "consequently";|];
  [| Str "curiously";|];
  [| Str "fortunately";|];
  [| Str "unfortunately";|];
  [| Str "surprisingly";|];
  [| Str "unsurprisingly";|];
  [| Str "quite simply";|];
  [| Str "in short";|];
|]

and recently = Opts [|
  [| Str "recently";|];
  [| Str "in recent years";|];
  [| Str "in recent papers";|];
  [| Str "over the last decade";|];
  [| Str "in the 20th century";|];
  [| Str "among particle physicists";|];
  [| Str "among mathematicians";|];
|]

and thereby = Opts [|
  [| thereby; Str " "; thereby;|];
  [| Str "thereby";|];
  [| Str "completely";|];
  [| Str "conclusively";|];
  [| Str "wholly";|];
  [| Str "thoroughly";|];
  [| Str "fully";|];
  [| Str "ultimately";|];
  [| Str "unambiguously";|];
|]

and motivated = Opts [|
  [| Str "motivated by this";|];
  [| Str "inspired by this";|];
  [| Str "continuing in this vein";|];
  [| Str "continuing with this program";|];
|]

and assuming = Opts [|
  [| Str "if";|];
  [| Str "whenever";|];
  [| Str "provided that";|];
  [| Str "supposing that";|];
  [| Str "assuming";|];
  [| Str "assuming that";|];
  [| Str "as long as";|];
  [| Str "given that";|];
|]

and preposition = Opts [|
  [| Str "after";|];
  [| Str "before";|];
  [| Str "while";|];
  [| Str "when";|];
|]

and whenphrase = Opts [|
  [| preposition; Str " "; studyingverb; Str " "; subject;|];
|]

and actiondone = Opts [|
  [| Str "reduction";|];
  [| Str "compactification";|];
  [| Str "formulation";|];
  [| Str "extension";|];
  [| Str "solution";|];
  [| Str "analytic continuation";|];
|]

and qualifier = Opts [|
  [| Str "at least in the context of "; subject;|];
  [| Str "without regard to "; subject;|];
  [| Str "in the approximation that "; statement;|];
  [| Str "in the limit that "; statement;|];
  [| Str "as realized in "; subject;|];
  [| Str "as hinted at by "; physicist;|];
  [| Str "as revealed by "; mathconcept;|];
  [| Str "by "; symmetry; Str " symmetry";|];
  [| Str "by symmetry";|];
  [| Str "whenever "; statement;|];
  [| Str "as we will see in this paper";|];
  [| Str "with the help of "; subject;|];
  [| Str "as will be made clear";|];
  [| Str "as will be "; studiedverb; Str " shortly";|];
  [| Str "in the "; singmathconcept; Str " case";|];
|]

and inorderto = Opts [|
  [| Str "to "; prove; Str " that "; statement;|];
  [| Str "in order to "; prove; Str " that "; statement;|];
  [| Str "in order to avoid "; studyingverb; Str " "; subject;|];
  [| Str "to best "; studyverb; Str " "; subject;|];
  [| Str "to "; studyverb; Str " "; subject;|];
  [| Str "to "; studyverb; Str " recent results linking "; subject; Str " and "; subject;|];
  [| Str "in a way that "; yields; Str " "; subject;|];
  [| Str "to explore questions such as the "; singmathconcept; Str " conjecture";|];
|]

and was = Opts [|
  [| Str "has been";|];
  [| Str "was";|];
|]

and muchwork = Opts [|
  [| Str "much work "; was; Str " done";|];
  [| Str "interesting progress "; was; Str " made";|];
  [| Str "substantial progress has been made";|];
  [| Str "minimal progress "; was; Str " made";|];
  [| Str "some work "; was; Str " done";|];
  [| Str "little work "; was; Str " done";|];
  [| Str "a fair amount of work "; was; Str " done";|];
  [| Str "partial progress "; was; Str " made";|];
|]

and test = Opts [|
  [| computation;|];
  [| Str "test";|];
  [| Str "probe";|];
  [| Str "measurement";|];
  [| Str "check";|];
|]

and computation = Opts [|
  [| Str "computation";|];
  [| Str "calculation";|];
  [| Str "determination";|];
|]

and correspondence = Opts [|
  [| Str "correspondence";|];
  [| Str "conjecture";|];
  [| Str "theorem";|];
  [| Str "result";|];
|]

and fact = Opts [|
  [| Str "fact";|];
  [| Str "truth";|];
  [| Str "principle";|];
  [| Str "law";|];
  [| Str "theorem";|];
  [| Str "rule";|];
  [| Str "pattern";|];
  [| Str "structure";|];
  [| Str "framework";|];
  [| Str "edifice";|];
|]

and thesame = Opts [|
  [| Str "the same";|];
  [| Str "the very same";|];
  [| Str "our very same";|];
  [| Str "our";|];
  [| Str "the exact same";|];
  [| Str "a previously studied";|];
|]

and beautiful = Opts [|
  [| Str "beautiful";|];
  [| Str "surprising";|];
  [| Str "elegant";|];
  [| Str "pretty";|];
  [| Str "arresting";|];
  [| Str "charming";|];
  [| Str "simple";|];
  [| Str "ingenious";|];
  [| Str "sophisticated";|];
  [| Str "intricate";|];
  [| Str "elaborate";|];
  [| Str "detailed";|];
  [| Str "confusing";|];
  [| Str "bewildering";|];
  [| Str "perplexing";|];
  [| Str "elaborate";|];
  [| Str "involved";|];
  [| Str "complicated";|];
  [| Str "startling";|];
  [| Str "unforseen";|];
  [| Str "amazing";|];
  [| Str "extraordinary";|];
  [| Str "remarkable";|];
  [| Str "shocking";|];
  [| Str "unexpected";|];
  [| Str "deep";|];
  [| Str "mysterious";|];
  [| Str "profound";|];
  [| Str "unsurprising";|];
  [| Str "essential";|];
  [| Str "fundamental";|];
  [| Str "crucial";|];
  [| Str "critical";|];
  [| Str "key";|];
  [| Str "important";|];
|]

and statement = Opts [|
  [| singsubject; Str " "; singstatementverb; Str " "; singsubject;|];
  [| pluralsubject; Str " "; pluralstatementverb; Str " "; subject;|];
  [| singsubject; Str " is "; descriptivephysadj;|];
  [| pluralsubject; Str " are "; descriptivephysadj;|];
|]

and asentence = Opts [|
  [| asentence; Str ", "; qualifier;|];
  [| recently; Str ", "; muchwork; Str " on "; model;|];
  [| recently; Str ", "; muchwork; Str " "; studyingverb; Str " "; theory;|];
  [| recently; Str ", "; muchwork; Str " on "; model; Str " "; inorderto;|];
  [| recently; Str ", "; muchwork; Str " "; studyingverb; Str " "; theory; Str " "; inorderto;|];
  [| muchwork; Str " "; recently; Str " on "; model;|];
  [| muchwork; Str " "; recently; Str " "; studyingverb; Str " "; theory;|];
  [| recently; Str ", work on "; model; Str " has opened up a "; descriptivephysadj; Str " class of "; physadj; Str " models";|];
  [| recently; Str ", "; physicistname; Str " "; studiedverb; Str " "; subject;|];
  [| recently; Str ", "; physicistname; Str " "; verbed; Str " that "; statement;|];
  [| asentence; Str ". we take a "; descriptivephysadj; Str " approach";|];
  [| asentence; Str ". "; motivated; Str ", "; bsentence;|];
  [| singsubject; Str " offers the possibility of "; studyingverb; Str " "; subject;|];
  [| subject; Str " "; yields; Str " a "; beautiful; Str " framework for "; studyingverb; Str " "; subject;|];
  [| singsubject; Str " is usually "; verbed; Str " "; via; Str " "; subject;|];
  [| pluralsubject; Str " are usually "; verbed; Str " "; via; Str " "; subject;|];
|]

and bsentence = Opts [|
  [| bsentence; Str ", "; qualifier;|];
  [| inorderto; Str ", "; bsentence;|];
  [| Str "we "; studyverb; Str " "; subject;|];
  [| Str "we solve "; problem;|];
  [| Str "we take a "; descriptivephysadj; Str " approach to "; subject;|];
  [| Str "we "; prove; Str " that "; statement;|];
  [| Str "we "; prove; Str " a "; beautiful; Str " correspondence between "; subject; Str " and "; subject;|];
  [| bsentence; Str ", and "; studyverb; Str " "; subject;|];
  [| bsentence; Str ", and "; verb; Str " that "; statement;|];
  [| bsentence; Str ", and "; verb; Str " that, "; qualifier; Str ", "; statement;|];
  [| bsentence; Str ", "; thereby; Str " "; studyingverb; Str " that "; statement;|];
  [| via; Str " "; studyingverb; Str " "; pluralmathconcept; Str ", we "; studyverb; Str " "; subject;|];
  [| via; Str " "; studyingverb; Str " "; physconcept; Str ", we "; studyverb; Str " "; subject;|];
  [| Str "we "; verb; Str " evidence for "; subject;|];
  [| Str "using the behavior of "; singsubject; Str ", we "; studyverb; Str " "; subject;|];
  [| Str "we present a criterion for "; subject;|];
  [| Str "we make contact with "; subject; Str ", "; adverb; Str " "; studyingverb; Str " "; subject;|];
  [| Str "we make contact between "; subject; Str " and "; subject;|];
  [| Str "we "; studyverb; Str " why "; statement;|];
  [| Str "we use "; subject; Str " to "; studyverb; Str " "; subject;|];
  [| Str "we use "; subject; Str ", together with "; subject; Str " to "; studyverb; Str " "; subject;|];
  [| Str "in this paper, "; bsentence;|];
|]

and csentence = Opts [|
  [| csentence; Str ", "; qualifier;|];
  [| motivated; Str ", "; bsentence;|];
  [| Str "we take a "; descriptivephysadj; Str " approach";|];
  [| adverb; Str ", "; statement;|];
  [| Str "next, "; bsentence;|];
  [| singtheory; Str " is also "; studiedverb;|];
  [| pluraltheory; Str " are also "; studiedverb;|];
  [| singmodel; Str " is also "; studiedverb;|];
  [| pluralmodel; Str " are also "; studiedverb;|];
  [| singphysconcept; Str " is also "; studiedverb;|];
  [| pluralphysconcept; Str " are also "; studiedverb;|];
  [| Str "we "; thereby; Str " "; prove; Str " a "; beautiful; Str " correspondence between "; subject; Str " and "; subject;|];
  [| Str "we also "; verb; Str " agreement with "; subject;|];
  [| Str "the "; computation; Str " of "; physconcept; Str " localizes to "; space;|];
  [| statement; Str " "; assuming; Str " "; statement;|];
  [| subject; Str " "; revealed; Str " a "; beautiful; Str " "; fact; Str ": "; statement;|];
  [| studyingverb; Str " is made easier by "; studyingverb; Str " "; subject;|];
  [| Str "our "; computation; Str " of "; subject; Str " "; yields; Str " "; subject;|];
  [| Str "as an interesting outcome of this work for "; subject; Str ", "; bsentence;|];
  [| csentence; Str ", "; studyingverb; Str " "; subject;|];
  [| adverb; Str ", "; singsubject; Str " "; singstatementverb; Str " "; thesame; Str " "; singmathconcept;|];
  [| Str "we therefore "; contradict; Str " a result of "; physicistname; Str " that "; statement;|];
  [| Str "this probably "; singstatementverb; Str " "; subject; Str ", though we've been unable to "; prove; Str " a "; correspondence;|];
  [| Str "this is most likely a result of "; physsubject; Str ", an observation first mentioned in work on "; subject;|];
  [| Str "this "; yields; Str " an extremely precise "; test; Str " of "; singphysconcept;|];
  [| Str "the "; singmathconcept; Str " depends, "; adverb; Str ", on whether "; statement;|];
  [| Str "a "; beautiful; Str " part of this analysis "; singstatementverb; Str " "; subject;|];
  [| Str "in this "; correspondence; Str ", "; singsubject; Str " makes a "; beautiful; Str " appearance";|];
  [| Str "why this happens can be "; studiedverb; Str " by "; studyingverb; Str " "; subject;|];
  [| Str "the title of this article refers to "; subject;|];
  [| Str "we "; verb; Str " that "; singtheoryobj; Str " "; singbeingverb; Str " "; qualifier;|];
  [| Str "this "; correspondence; Str " has long been understood in terms of "; subject;|];
|]

and dsentence = Opts [|
  [| dsentence; Str ", "; qualifier;|];
  [| whenphrase; Str ", we "; verb; Str " that "; statement;|];
  [| statement;|];
  [| whenphrase; Str ", we "; verb; Str " that, "; qualifier; Str ", "; statement;|];
  [| dsentence; Str ". "; adverb; Str ", "; dsentence;|];
  [| Str "our results "; prove; Str " that "; statement;|];
|]

and closing = Opts [|
  [| Str "finally, "; bsentence;|];
  [| adverb; Str ", there is much to be done";|];
  [| Str "we hope this paper provides a good starting point for "; studyingverb; Str " "; subject;|];
  [| Str "we leave the rest for future study";|];
  [| adverb; Str ", "; singsubject; Str " is beyond the scope of this paper";|];
  [| Str "we will provide more details in a future paper";|];
  [| Str "our results are similar to work done by "; physicistname;|];
  [| Str "we believe this is indicative of a "; beautiful; Str " "; fact;|];
  [| Str "given this, our work may seem quite "; beautiful;|];
|]

and abstract = Opts [|
  [| asentence; Str ". "; bsentence; Str ". "; csentence; Str ". "; dsentence; Str ".";|];
  [| asentence; Str ". "; adverb; Str ", "; asentence; Str ". "; bsentence; Str ". "; csentence; Str ". "; dsentence; Str ".";|];
  [| asentence; Str ". "; bsentence; Str ". "; csentence; Str ". "; dsentence; Str ". "; closing; Str ".";|];
  [| asentence; Str ". "; adverb; Str ", "; asentence; Str ". "; bsentence; Str ". "; csentence; Str ". "; dsentence; Str ". "; closing; Str ".";|];
  [| statement; Str ". "; csentence; Str ". "; csentence; Str ". "; dsentence; Str ".";|];
  [| statement; Str ". "; adverb; Str ", "; asentence; Str ". "; csentence; Str ". "; csentence; Str ". "; dsentence; Str ".";|];
  [| statement; Str ". "; adverb; Str ", "; asentence; Str ". "; csentence; Str ". "; csentence; Str ". "; dsentence; Str ". "; closing; Str ".";|];
  [| bsentence; Str ". "; csentence; Str ". "; adverb; Str ", "; asentence; Str ". "; csentence; Str ". "; csentence; Str ". "; dsentence; Str ".";|];
  [| bsentence; Str ". "; csentence; Str ". "; dsentence; Str ". "; adverb; Str ", "; asentence; Str ". "; csentence; Str ". "; closing; Str ".";|];
|]

and title = Opts [|
  [| subject;|];
  [| fancytitle;|];
  [| fancytitle;|];
|]

and fancytitle = Opts [|
  [| subject; Str " and "; subject;|];
  [| subject; Str " and "; subject;|];
  [| subject; Str " and "; subject;|];
  [| Str "from "; subject; Str " to "; subject;|];
  [| subject; Str " "; verbed; Str " "; via; Str " "; pluralmathconcept;|];
  [| Str "towards "; subject;|];
  [| subject; Str " "; via; Str " "; subject;|];
  [| subject; Str " as "; subject;|];
  [| studyingverb; Str " "; subject;|];
  [| studyingverb; Str " "; subject; Str ": "; subject;|];
  [| soladj; Str " approaches to "; problem;|];
  [| Str "why "; pluralsubject; Str " are "; descriptivephysadj;|];
  [| studyingverb; Str " "; subject; Str ": a "; descriptivephysadj; Str " approach";|];
  [| Str "on "; subject;|];
  [| Str "progress in "; subject;|];
|]

and author = Opts [|
  [| capital; Str ". "; physicistname;|];
  [| capital; Str ". "; capital; Str ". "; physicistname;|];
|]

and authors = Opts [|
  [| author;|];
  [| author; Str ", "; authors;|];
|]

and morecomments = Opts [|
  [| smallinteger; Str " figures";|];
  [| Str "JHEP style";|];
  [| Str "Latex file";|];
  [| Str "no figures";|];
  [| Str "BibTeX";|];
  [| Str "JHEP3";|];
  [| Str "typos corrected";|];
  [| nzdigit; Str " tables";|];
  [| Str "added refs";|];
  [| Str "minor changes";|];
  [| Str "minor corrections";|];
  [| Str "published in PRD";|];
  [| Str "reference added";|];
  [| Str "pdflatex";|];
  [| Str "based on a talk given on "; physicistname; Str "'s "; nzdigit; Str "0th birthday";|];
  [| Str "talk presented at the international "; pluralphysconcept; Str " workshop";|];
|]

and comments = Opts [|
  [| smallinteger; Str " pages";|];
  [| comments; Str ", "; morecomments;|];
|]

and primarysubj = Opts [|
  [| Str "High Energy Physics - Theory (hep-th)";|];
  [| Str "High Energy Physics - Phenomenology (hep-ph)";|];
|]

and secondarysubj = Opts [|
  [| Str "Nuclear Theory (nucl-th)";|];
  [| Str "Cosmology and Extragalactic Astrophysics (astro-ph.CO)";|];
  [| Str "General Relativity and Quantum Cosmology (gr-qc)";|];
  [| Str "Statistical Mechanics (cond-mat.stat-mech)";|];
|]

and papersubjects = Opts [|
  [| primarysubj;|];
  [| papersubjects; Str "; "; secondarysubj;|];
|]

and paper = Opts [|
  [| title; Str " \\\\ "; authors; Str " \\\\ "; comments; Str " \\\\ "; papersubjects; Str " \\\\ "; abstract; Str " ";|];
|]

let _ = print top
let _ = print_string "\n"