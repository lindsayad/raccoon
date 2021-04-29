//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "CustomParsedFunctionBase.h"

/**
 * Class to evaluate the crack geometric function and automatically provide all derivatives.
 */
class CrackGeometricFunction : public CustomParsedFunctionBase
{
public:
  static InputParameters validParams();

  CrackGeometricFunction(const InputParameters & parameters);

protected:
  void computeQpProperties() override;

private:
  ADReal computeNormalizationConstant();
  ADReal normalizationIntegrand(ADReal d);

  unsigned int _d_idx;

  ADMaterialProperty<Real> & _xi;
  ADMaterialProperty<Real> & _c0;

  Real _tolerance;
  unsigned int _max_its;

  ADReal _xi_0;
  ADReal _c0_0;
};