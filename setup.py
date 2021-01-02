from distutils.core import setup
from Cython.Build import cythonize

setup(
    ext_modules=cythonize(["NER/AutoProcessor/ParseTree/*.pyx",
                           "NER/AutoProcessor/Sentence/*.pyx"],
                          compiler_directives={'language_level': "3"}),
    name='NlpToollkit-NER-Cy',
    version='1.0.0',
    packages=['NER', 'NER.AutoProcessor', 'NER.AutoProcessor.Sentence', 'NER.AutoProcessor.ParseTree'],
    url='',
    license='',
    author='olcaytaner',
    author_email='olcay.yildiz@ozyegin.edu.tr',
    description='NER library'
)
