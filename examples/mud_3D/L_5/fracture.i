[Functions]
  [./psic]
    type = PiecewiseMultilinear
    data_file = '../gold/psic_L_5_rho_0_sample_1.txt'
  [../]
  [./Gc]
    type = PiecewiseMultilinear
    data_file = '../gold/Gc_L_5_rho_0_sample_1.txt'
  [../]
[]

[MultiApps]
  [./mechanical]
    type = TransientMultiApp
    input_files = 'mechanical.i'
    app_type = raccoonApp
    execute_on = 'TIMESTEP_END'
  [../]
[]

[Transfers]
  [./get_E_el]
    type = MultiAppCopyTransfer
    multi_app = mechanical
    direction = from_multiapp
    source_variable = 'E_el'
    variable = 'E_el'
  [../]
  [./send_load]
    type = MultiAppScalarToAuxScalarTransfer
    multi_app = mechanical
    direction = to_multiapp
    source_variable = 'load'
    to_aux_scalar = 'load'
  [../]
  [./send_d]
    type = MultiAppCopyTransfer
    multi_app = mechanical
    direction = to_multiapp
    source_variable = 'd'
    variable = 'd'
  [../]
[]

[Mesh]
  type = FileMesh
  file = '../gold/geo.msh'
[]

[Variables]
  [./d]
  [../]
[]

[AuxVariables]
  [./load]
    family = SCALAR
  [../]
  [./E_el]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./d_ref]
  [../]
  [./bounds_dummy]
  [../]
[]

[Bounds]
  [./irreversibility]
    type = Irreversibility
    variable = bounds_dummy
    bounded_variable = d
    upper = 1
    lower = d_ref
  [../]
[]

[Kernels]
  [./damage]
    type = PhaseFieldFractureEvolution
    variable = d
    driving_energy_var = E_el
  [../]
[]

[Materials]
  [./fracture_energy_barrier_film]
    type = StationaryGenericFunctionMaterial
    prop_names = 'b'
    prop_values = 'psic'
  [../]
  [./fracture_properties_film]
    type = FractureMaterial
    Gc = 'Gc'
    L = 0.5
    local_dissipation_norm = 8/3
  [../]
  [./local_dissipation]
    type = LinearLocalDissipation
    d = d
  [../]
  [./degradation]
    type = LorentzDegradation
    d = d
    residual_degradation = 1e-06
  [../]
[]

[Executioner]
  type = TransientSupNorm
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -snes_type'
  petsc_options_value = 'lu vinewtonrsls'
  dt = 1e-4

  nl_abs_tol = 1e-06
  nl_rel_tol = 1e-06
[]

[Outputs]
  hide = 'load'
[]