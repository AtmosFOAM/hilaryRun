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

Description
    Template for use with codeStream.

\*---------------------------------------------------------------------------*/

#include "dictionary.H"
#include "Ostream.H"
#include "Pstream.H"
#include "unitConversion.H"

//{{{ begin codeInclude
#line 24 "/home/hilary/OpenFOAM/hilary-7/run/hilary/boundaryLayer/Leipzig/fine/constant/dbdz.#codeStream"
#include "fvCFD.H"
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
    void codeStream_8461f68d2943a181ec4e273a2fe067da9d405fd4
    (
        Ostream& os,
        const dictionary& dict
    )
    {
//{{{ begin code
        #line 39 "/home/hilary/OpenFOAM/hilary-7/run/hilary/boundaryLayer/Leipzig/fine/constant/dbdz.#codeStream"
const IOdictionary& d = static_cast<const IOdictionary&>(dict);
        const fvMesh& mesh = refCast<const fvMesh>(d.db());

        // Set constants specific to the buoyancy profile
        const scalar ustar = 0.65;
        const scalar L  = 580;
        const scalar beta = 4.7;
        const scalar zMid = 100;
        const scalar heightScale = 520;
        
        // Look up coefficients set elsewhere (or just set them here)
        const scalar z0 = 0.3;
        const scalar sigmaTheta = 0.74;
        const scalar kappa = 0.41;
        
        // z from the mesh
        const scalarField z = mesh.C().component(2);

        scalarField dbdz(mesh.nCells(), scalar(0));
        forAll(dbdz, cellI)
        {
            dbdz[cellI] = sigmaTheta*(sigmaTheta + beta*z[cellI]/L)*sqr(ustar)
                    /(sigmaTheta*sqr(kappa)*z[cellI]*L);
            if (z[cellI] > zMid)
            {
                dbdz[cellI] *= exp(-(z[cellI]-zMid)/heightScale);
            }
        }
        
        const scalar dbdz_z0 = sigmaTheta*(sigmaTheta + beta*z0/L)*sqr(ustar)
                    /(sigmaTheta*sqr(kappa)*z0*L);
        Info << "dbdz_z0 = " << dbdz_z0 << endl;
        os << dbdz;
//}}} end code
    }
}


// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

} // End namespace Foam

// ************************************************************************* //

