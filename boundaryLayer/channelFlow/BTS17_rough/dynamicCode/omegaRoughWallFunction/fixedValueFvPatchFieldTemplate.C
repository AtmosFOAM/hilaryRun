/*---------------------------------------------------------------------------*\
  =========                 |
  \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
   \\    /   O peration     | Website:  https://openfoam.org
    \\  /    A nd           | Copyright (C) YEAR OpenFOAM Foundation
     \\/     M anipulation  |
-------------------------------------------------------------------------------
License
    This file is part of OpenFOAM.

    OpenFOAM is free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    OpenFOAM is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
    FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
    for more details.

    You should have received a copy of the GNU General Public License
    along with OpenFOAM.  If not, see <http://www.gnu.org/licenses/>.

\*---------------------------------------------------------------------------*/

#include "fixedValueFvPatchFieldTemplate.H"
#include "addToRunTimeSelectionTable.H"
#include "fvPatchFieldMapper.H"
#include "volFields.H"
#include "surfaceFields.H"
#include "unitConversion.H"
//{{{ begin codeInclude
#line 76 "/home/hilary/OpenFOAM/hilary-7/run/hilary/channelFlow/BTS17_rough/0/omega.boundaryField.ground"
#include "fvCFD.H"
            #include "nutkRoughWallFunctionFvPatchScalarField.H"
            #include "turbulenceModel.H"
//}}} end codeInclude


// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

namespace Foam
{

// * * * * * * * * * * * * * * * Local Functions * * * * * * * * * * * * * * //

//{{{ begin localCode

//}}} end localCode


// * * * * * * * * * * * * * * * Global Functions  * * * * * * * * * * * * * //

extern "C"
{
    // dynamicCode:
    // SHA1 = d7ac75842eaf65f2020a1f3659b62714abc6c37c
    //
    // unique function name that can be checked if the correct library version
    // has been loaded
    void omegaRoughWallFunction_d7ac75842eaf65f2020a1f3659b62714abc6c37c(bool load)
    {
        if (load)
        {
            // code that can be explicitly executed after loading
        }
        else
        {
            // code that can be explicitly executed before unloading
        }
    }
}

// * * * * * * * * * * * * * * Static Data Members * * * * * * * * * * * * * //

makeRemovablePatchTypeField
(
    fvPatchScalarField,
    omegaRoughWallFunctionFixedValueFvPatchScalarField
);


const char* const omegaRoughWallFunctionFixedValueFvPatchScalarField::SHA1sum =
    "d7ac75842eaf65f2020a1f3659b62714abc6c37c";


// * * * * * * * * * * * * * * * * Constructors  * * * * * * * * * * * * * * //

omegaRoughWallFunctionFixedValueFvPatchScalarField::
omegaRoughWallFunctionFixedValueFvPatchScalarField
(
    const fvPatch& p,
    const DimensionedField<scalar, volMesh>& iF
)
:
    fixedValueFvPatchField<scalar>(p, iF)
{
    if (false)
    {
        Info<<"construct omegaRoughWallFunction sha1: d7ac75842eaf65f2020a1f3659b62714abc6c37c"
            " from patch/DimensionedField\n";
    }
}


omegaRoughWallFunctionFixedValueFvPatchScalarField::
omegaRoughWallFunctionFixedValueFvPatchScalarField
(
    const omegaRoughWallFunctionFixedValueFvPatchScalarField& ptf,
    const fvPatch& p,
    const DimensionedField<scalar, volMesh>& iF,
    const fvPatchFieldMapper& mapper
)
:
    fixedValueFvPatchField<scalar>(ptf, p, iF, mapper)
{
    if (false)
    {
        Info<<"construct omegaRoughWallFunction sha1: d7ac75842eaf65f2020a1f3659b62714abc6c37c"
            " from patch/DimensionedField/mapper\n";
    }
}


omegaRoughWallFunctionFixedValueFvPatchScalarField::
omegaRoughWallFunctionFixedValueFvPatchScalarField
(
    const fvPatch& p,
    const DimensionedField<scalar, volMesh>& iF,
    const dictionary& dict
)
:
    fixedValueFvPatchField<scalar>(p, iF, dict)
{
    if (false)
    {
        Info<<"construct omegaRoughWallFunction sha1: d7ac75842eaf65f2020a1f3659b62714abc6c37c"
            " from patch/dictionary\n";
    }
}


omegaRoughWallFunctionFixedValueFvPatchScalarField::
omegaRoughWallFunctionFixedValueFvPatchScalarField
(
    const omegaRoughWallFunctionFixedValueFvPatchScalarField& ptf
)
:
    fixedValueFvPatchField<scalar>(ptf)
{
    if (false)
    {
        Info<<"construct omegaRoughWallFunction sha1: d7ac75842eaf65f2020a1f3659b62714abc6c37c"
            " as copy\n";
    }
}


omegaRoughWallFunctionFixedValueFvPatchScalarField::
omegaRoughWallFunctionFixedValueFvPatchScalarField
(
    const omegaRoughWallFunctionFixedValueFvPatchScalarField& ptf,
    const DimensionedField<scalar, volMesh>& iF
)
:
    fixedValueFvPatchField<scalar>(ptf, iF)
{
    if (false)
    {
        Info<<"construct omegaRoughWallFunction sha1: d7ac75842eaf65f2020a1f3659b62714abc6c37c "
            "as copy/DimensionedField\n";
    }
}


// * * * * * * * * * * * * * * * * Destructor  * * * * * * * * * * * * * * * //

omegaRoughWallFunctionFixedValueFvPatchScalarField::
~omegaRoughWallFunctionFixedValueFvPatchScalarField()
{
    if (false)
    {
        Info<<"destroy omegaRoughWallFunction sha1: d7ac75842eaf65f2020a1f3659b62714abc6c37c\n";
    }
}


// * * * * * * * * * * * * * * * Member Functions  * * * * * * * * * * * * * //

void omegaRoughWallFunctionFixedValueFvPatchScalarField::updateCoeffs()
{
    if (this->updated())
    {
        return;
    }

    if (false)
    {
        Info<<"updateCoeffs omegaRoughWallFunction sha1: d7ac75842eaf65f2020a1f3659b62714abc6c37c\n";
    }

//{{{ begin code
    #line 36 "/home/hilary/OpenFOAM/hilary-7/run/hilary/channelFlow/BTS17_rough/0/omega.boundaryField.ground"
const scalar omegaWallC = 1.2;
            const label patchi = this->patch().index();

            const turbulenceModel& turbModel
                 = this->db().lookupObject<turbulenceModel>
            (
                IOobject::groupName
                (
                    turbulenceModel::propertiesName,
                    this->internalField().group()
                )
            );

            const nutkRoughWallFunctionFvPatchScalarField& nutw =
                refCast<const nutkRoughWallFunctionFvPatchScalarField>
            (
                turbModel.nut()().boundaryField()[patchi]
            );

            const tmp<volScalarField> tk = turbModel.k();
            const volScalarField& k = tk();

            const scalar Cmu25 = pow025(nutw.Cmu());
            
            scalarField omega(this->patch().size(), 0);

            forAll(omega, i)
            {
                const label celli = this->patch().faceCells()[i];
                const scalar uStar = Cmu25*sqrt(k[celli]);
                scalar nu = turbModel.nu()().boundaryField()[patchi][i];
                scalar ksPlus = nutw.Cs()[i]*nutw.Ks()[i]*uStar/nu;
                scalar SR = ksPlus < 25 ? sqr(50/ksPlus) : 100/ksPlus;
                omega[i] = omegaWallC*sqr(uStar)*SR/nu;
            }
            operator==(omega);
//}}} end code

    this->fixedValueFvPatchField<scalar>::updateCoeffs();
}


// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

} // End namespace Foam

// ************************************************************************* //

